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
public typealias NSUIView = NSView

#elseif os(iOS)
import UIKit
public typealias NSUIColor = UIColor
public typealias NSUIFont = UIFont
public typealias NSUIEvent = UIEvent
public typealias NSUIMenu = UIMenu
public typealias NSUIImage = UIImage
public typealias NSUIView = UIView
#else
#error("unsupported platform")
#endif

// MARK: NSView/UIView
#if os(macOS)
import AppKit
public typealias NSUIScrollView = NSScrollView
#elseif os(iOS)
import UIKit
public typealias NSUIScrollView = UIScrollView // note: UITextView inherits UIScrollView
#endif
