import Foundation
import os.log
import CoreText
import CoreGraphics
import CryptoKit

#if canImport(UIKit)
    import UIKit

    public typealias SoloFont = UIFont
#endif

#if canImport(AppKit)
    import AppKit

    public typealias SoloFont = NSFont
#endif

#if canImport(CoreLocation)
    import CoreLocation
#endif
