//
//  File.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/05
//  © 2023  SmallDeskSoftware
//

import Foundation
import CoreImage
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

extension NSUIImage {
#if os(macOS)
    // compatible with UIImage
    public convenience init(ciImage: CIImage) {
        let rep = NSBitmapImageRep(ciImage: ciImage)
        self.init(size: .zero)
        addRepresentation(rep)
    }

#elseif os(iOS)
    // compatible with NSImage
    public convenience init?(systemSymbolName: String, accessibilityDescription: String?) {
        self.init(systemName: systemSymbolName)
    }
    // compatible with NSImage
    public convenience init?(contentsOf url: URL) {
        self.init(contentsOfFile: url.absoluteString)
    }
    public convenience init(cgImage: CGImage, size: CGSize) {
        let scale = size.width / CGFloat(cgImage.width)
        self.init(cgImage: cgImage, scale: scale, orientation: UIImage.Orientation.up)
    }

#endif
#if os(macOS)
    public var toCGImage: CGImage? {
        return cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    public var toCIImage: CIImage? {
        //guard let imageData = self.tiffRepresentation else { return nil }
        guard let imageData = self.tiffRepresentation(using: .none, factor: 0.0) else { return nil }
        guard let bitmap = NSBitmapImageRep(data: imageData) else { return nil }
        //return CIImage(data: imageData)
        return CIImage(bitmapImageRep: bitmap)
    }
#elseif os(iOS)
    public var toCGImage: CGImage? {
        return self.cgImage
    }
    public var toCIImage: CIImage? {
        if let ciImage = self.ciImage { return ciImage }
        if let cgImage = self.cgImage {
            return CIImage(cgImage: cgImage)
        }
        return nil
    }
#endif
}

extension Image {
    public init(nsuiImage: NSUIImage) {
#if os(macOS)
        self.init(nsImage: nsuiImage)
#elseif os(iOS)
        self.init(uiImage: nsuiImage)
#endif
    }
}
