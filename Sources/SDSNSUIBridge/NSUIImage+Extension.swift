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

    public enum NSUIImageOrientation: String, RawRepresentable {
        // swiftlint:disable:next identifier_name
        case up, down, left, right
        case upMirrored, downMirrored, leftMirrored, rightMirrored
        //UIImageOrientationUp,            // default orientation
        //UIImageOrientationDown,          // 180 deg rotation
        //UIImageOrientationLeft,          // 90 deg CCW
        //UIImageOrientationRight,         // 90 deg CW
        //UIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
        //UIImageOrientationDownMirrored,  // horizontal flip
        //UIImageOrientationLeftMirrored,  // vertical flip
        //UIImageOrientationRightMirrored, // vertical flip
    }

    public var nsuiImageOrientation: NSUIImage.NSUIImageOrientation {
#if os(macOS)
        return .up
#elseif os(iOS)
        switch self.imageOrientation {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        case .upMirrored:
            return .upMirrored
        case .downMirrored:
            return .downMirrored
        case .leftMirrored:
            return .leftMirrored
        case .rightMirrored:
            return .rightMirrored
        @unknown default:
            return .up
        }
#endif
    }
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
extension NSUIImage {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func orientationFixed() -> NSUIImage {
        #if os(macOS)
        return self
        #elseif os(iOS)
        guard self.imageOrientation != .up else {
            return self
        }

        let size = self.size
        let imageOrientation = self.imageOrientation

        var transform: CGAffineTransform = .identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }

        guard var cgImage = self.cgImage else {
            return self
        }

        autoreleasepool {
            var context: CGContext?

            guard let colorSpace = cgImage.colorSpace,
                  let tmpContext = CGContext(data: nil, width: Int(self.size.width),
                                             height: Int(self.size.height),
                                             bitsPerComponent: cgImage.bitsPerComponent,
                                             bytesPerRow: 0, space: colorSpace,
                                             bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                return
            }
            context = tmpContext

            context?.concatenate(transform)

            var drawRect: CGRect = .zero
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                drawRect.size = CGSize(width: size.height, height: size.width)
            default:
                drawRect.size = CGSize(width: size.width, height: size.height)
            }

            context?.draw(cgImage, in: drawRect)

            guard let newCGImage = context?.makeImage() else {
                return
            }
            cgImage = newCGImage
        }

        return UIImage(cgImage: cgImage, scale: 1, orientation: .up)
        #endif
    }
}
