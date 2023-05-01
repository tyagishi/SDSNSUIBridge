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
public typealias NSUIEvent = NSEvent
public typealias NSUIMenu = NSMenu
public typealias NSUIImage = NSImage

#elseif os(iOS)
import UIKit
public typealias NSUIColor = UIColor
public typealias NSUIFont = UIFont
public typealias NSUIEvent = UIEvent
public typealias NSUIMenu = UIMenu
public typealias NSUIImage = UIImage
#else
#error("unsupported platform")
#endif

// MARK: NSView/UIView
#if os(macOS)
import AppKit
public typealias NSUITextView = NSTextView
public typealias NSUIScrollView = NSScrollView
#elseif os(iOS)
import UIKit
public typealias NSUITextView = UITextView
public typealias NSUIScrollView = UIScrollView // note: UITextView inherits UIScrollView
#endif

#if os(macOS)
public typealias EditActions = NSTextStorageEditActions
#elseif os(iOS)
public typealias EditActions = NSTextStorage.EditActions
#endif
