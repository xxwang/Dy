import Foundation
import os.log
import CoreText
import CoreGraphics
import CryptoKit

#if canImport(UIKit)
    import UIKit

    public typealias DyFont = UIFont
#endif

#if canImport(AppKit)
    import AppKit

    public typealias DyFont = NSFont
#endif

#if canImport(CoreLocation)
    import CoreLocation
#endif

extension String: DyExtension {}
