//
//  NSUIFont+Extension.swift
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

extension NSUIFont {
    public static func boldFont(ofSize fontSize: CGFloat) -> NSUIFont {
#if os(macOS)
        return NSFont.boldSystemFont(ofSize: fontSize)
#elseif os(iOS)
        return UIFont.boldSystemFont(ofSize: fontSize)
#endif
    }
    
    public static func italicFont(ofSize fontSize: CGFloat) -> NSUIFont {
#if os(macOS)
        return NSFontManager.shared.font(withFamily: NSUIFont.systemFont(ofSize: fontSize).fontName,
                                         traits: .italicFontMask,
                                         weight: 0, size: fontSize) ?? NSUIFont.systemFont(ofSize: fontSize)
#elseif os(iOS)
        return UIFont.italicSystemFont(ofSize: fontSize)
#endif
    }
    
    public static func boldItalicFont(ofSize fontSize: CGFloat) -> NSUIFont {
#if os(macOS)
        return NSFontManager.shared.font(withFamily: NSUIFont.systemFont(ofSize: fontSize).fontName,
                                         traits: [.italicFontMask,.boldFontMask],
                                         weight: 0, size: fontSize) ?? NSUIFont.systemFont(ofSize: fontSize)
#elseif os(iOS)
        guard let fontDesc = UIFont.systemFont(ofSize: fontSize).fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return UIFont(descriptor: fontDesc, size: fontSize)
#endif
    }
}

#if canImport(UIKit)
import UIKit
public struct NSFontTraitMask: OptionSet {
    public let rawValue: Int
    public static let boldFontMask = NSFontTraitMask(rawValue: 1 << 0)
    public static let unboldFontMask = NSFontTraitMask(rawValue: 1 << 1)
    public static let italicFontMask = NSFontTraitMask(rawValue: 1 << 2)
    public static let unitalicFontMask = NSFontTraitMask(rawValue: 1 << 3)
    public static let all: NSFontTraitMask = [.boldFontMask, .unboldFontMask, .italicFontMask, .unitalicFontMask]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
extension NSMutableAttributedString {
    public func applyFontTraits(_ traitMask: NSFontTraitMask, range: NSRange) {
        // swiftlint:disable:next unused_closure_parameter
        enumerateAttribute(.font, in: range, options: [.longestEffectiveRangeNotRequired]) { (attr, attrRange, stop) in
            guard let font = attr as? UIFont else { return }
            let descriptor = font.fontDescriptor
            var symbolicTraits = descriptor.symbolicTraits
            if traitMask.contains(.boldFontMask) {
                symbolicTraits.insert(.traitBold)
            }
            if symbolicTraits.contains(.traitBold) && traitMask.contains(.unboldFontMask) {
                symbolicTraits.remove(.traitBold)
            }
            if traitMask.contains(.italicFontMask) {
                symbolicTraits.insert(.traitItalic)
            }
            if symbolicTraits.contains(.traitItalic) && traitMask.contains(.unitalicFontMask) {
                symbolicTraits.remove(.traitItalic)
            }
            guard let newDescriptor = descriptor.withSymbolicTraits(symbolicTraits) else { return }
            let newFont = UIFont(descriptor: newDescriptor, size: font.pointSize)
            self.addAttribute(.font, value: newFont, range: attrRange)
        }
    }
}
#endif
