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
public typealias NSUIScrollView = NSScrollView

public typealias NSUIPasteboard = NSPasteboard

#elseif os(iOS)
import UIKit
public typealias NSUIColor = UIColor
public typealias NSUIFont = UIFont
public typealias NSUIEvent = UIEvent
public typealias NSUIMenu = UIMenu
public typealias NSUIImage = UIImage
public typealias NSUIView = UIView
public typealias NSUIScrollView = UIScrollView // note: UITextView inherits UIScrollView

public typealias NSUIPasteboard = UIPasteboard

#else
#error("unsupported platform")
#endif
