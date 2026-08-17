import AVFAudio

public extension SoloWrapper where Base: AVAudioSession {
    /// 设置音频会话为蓝牙耳机支持模式
    /// - Parameter isActive: 是否激活音频会话,默认为 `true`
    /// - Throws: 如果设置失败,抛出错误
    ///
    /// - Example:
    ///
    ///     do {
    ///         try AVAudioSession.solo.bluetoothSupport(active: true)
    ///         print("音频会话已激活并支持蓝牙耳机")
    ///     } catch {
    ///         print("音频会话设置失败:\(error.localizedDescription)")
    ///     }
    ///
    static func bluetoothSupport(isActive: Bool = true) throws {
        let session = Base.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .mixWithOthers])
        try session.setActive(isActive)
    }
}
