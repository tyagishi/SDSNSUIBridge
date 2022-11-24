//
//  NSUIColor+Extension.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/15
//  © 2022  SmallDeskSoftware
//

import Foundation

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension NSUIColor {
    static public var labelElementColor: NSUIColor {
#if os(macOS)
        return NSColor.labelColor
#elseif os(iOS)
        return UIColor.label
#endif
    }
#if os(iOS)
    static public var textColor: NSUIColor {
        return UIColor.label
    }
#endif
}
