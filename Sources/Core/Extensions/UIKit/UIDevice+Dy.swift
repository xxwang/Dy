
import AVKit
import CoreTelephony
import Security
import SystemConfiguration.CaptiveNetwork
import UIKit
import Darwin

// MARK: - 存储与内存信息
public extension UIDevice {
    /// 总磁盘容量(字节)
    static var dy_totalDiskCapacityInBytes: Int64 {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let space = attrs[.systemSize] as? NSNumber,
              space.int64Value > 0
        else {
            return -1
        }
        return space.int64Value
    }

    /// 可用磁盘容量(字节),优先使用 iOS 11+ 的重要用途容量
    static var dy_freeDiskCapacityInBytes: Int64 {
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        if #available(iOS 11.0, *) {
            do {
                let values = try homeURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
                return values.volumeAvailableCapacityForImportantUsage ?? 0
            } catch {}
        }

        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let free = attrs[.systemFreeSize] as? NSNumber
        {
            return free.int64Value
        }
        return 0
    }

    /// 已用磁盘容量(字节)
    static var dy_usedDiskCapacityInBytes: Int64 {
        let total = self.totalDiskCapacityInBytes
        let free = self.freeDiskCapacityInBytes
        guard total > 0, free >= 0 else { return -1 }
        let used = total - free
        return used > 0 ? used : -1
    }

    /// 物理内存总量(字节)
    static var dy_physicalMemoryInBytes: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
}

// MARK: - 设备控制(如闪光灯)
public extension UIDevice {
    /// 闪光灯当前是否开启
    static var dy_isTorchOn: Bool {
        guard let device = AVCaptureDevice.default(for: .video) else { return false }
        return device.torchMode == .on
    }

    /// 设置闪光灯开关状态
    /// - 自动处理配置锁和权限
    static func dy_setTorchMode(_ isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = isOn ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("setFlashlight error: \(error.localizedDescription)")
        }
    }
}

// MARK: - 网络信息
public extension UIDevice {
    /// 获取当前连接的 Wi-Fi 网络信息(SSID 和 BSSID)
    /// ⚠️ 需在 Xcode Capabilities 中启用 "Access WiFi Information"
    /// ⚠️ iOS 13+ 后台或未连接 VPN 时可能返回 (nil, nil)
    static var dy_connectedWiFiNetwork: (ssid: String?, bssid: String?) {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return (nil, nil)
        }

        for interface in interfaces {
            if let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject] {
                let ssid = info["SSID"] as? String
                let bssid = info["BSSID"] as? String
                if ssid != nil || bssid != nil {
                    return (ssid, bssid)
                }
            }
        }
        return (nil, nil)
    }

    /// 获取设备所有活动网络接口的 IP 地址(IPv4 + IPv6,不含 loopback)
    static var dy_allIPAddresses: [String] {
        var addresses: [String] = []
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return [] }

        defer { freeifaddrs(ifaddr) }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr

            guard (flags & (IFF_UP | IFF_RUNNING)) == (IFF_UP | IFF_RUNNING),
                  flags & IFF_LOOPBACK == 0,
                  addr != nil else { continue }

            let family = addr?.pointee.sa_family
            guard family == UInt8(AF_INET) || family == UInt8(AF_INET6) else { continue }

            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            let saLen = family == UInt8(AF_INET6) ? MemoryLayout<sockaddr_in6>.size : MemoryLayout<sockaddr_in>.size

            guard getnameinfo(addr, socklen_t(saLen), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else { continue }

            let ipString: String? = {
                if #available(iOS 18.0, *) {
                    return String(validating: hostname, as: UTF8.self)
                } else {
                    return String(cString: hostname)
                }
            }()

            if let ip = ipString {
                addresses.append(ip)
            }
        }
        return addresses
    }

    /// 获取 Wi-Fi 接口(en0)的 IP 地址(通常用于局域网通信)
    static var dy_wifiIPAddress: String? {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }

        defer { freeifaddrs(ifaddr) }

        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ptr.pointee
            let name = String(cString: interface.ifa_name)
            guard name == "en0" else { continue }

            let addr = interface.ifa_addr
            guard addr != nil,
                  addr?.pointee.sa_family == UInt8(AF_INET) || addr?.pointee.sa_family == UInt8(AF_INET6) else { continue }

            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            let saLen = addr?.pointee.sa_family == UInt8(AF_INET6) ? MemoryLayout<sockaddr_in6>.size : MemoryLayout<sockaddr_in>.size

            guard getnameinfo(addr, socklen_t(saLen), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else { continue }

            if #available(iOS 18.0, *) {
                return String(validating: hostname, as: UTF8.self)
            } else {
                return String(cString: hostname)
            }
        }
        return nil
    }
}
