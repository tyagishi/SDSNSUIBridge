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
#if os(iOS)
    static var labelColor: NSUIColor {
        UIColor.label
    }
#endif
}
