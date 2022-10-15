//
//  SDSNSUIBridge.swift
//
//  Created by : Tomoaki Yagishita on 2022/10/15
//  © 2022  SmallDeskSoftware
//

import Foundation

#if os(macOS)
import AppKit
public typealias NSUIColor = NSColor
public typealias NSUIFont = NSFont
#elseif os(iOS)
import UIKit
public typealias NSUIColor = UIColor
public typealias NSUIFont = UIFont
#else
#error("unsupported platform")
#endif

#if os(macOS)
public typealias EditActions = NSTextStorageEditActions
#elseif os(iOS)
public typealias EditActions = NSTextStorage.EditActions
#endif
