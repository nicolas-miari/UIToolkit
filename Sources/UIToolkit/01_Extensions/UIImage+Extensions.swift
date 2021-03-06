//
//  UIImage+Extensions.swift
//  Spotlighter
//
//  Created by Nicolás Miari on 2018/09/21.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit
import CGUtils

public extension UIImage {

    /**
     Forces the specified size, so aspect ratio is **not** preserved. In order
     to preserve aspect ratio, use `resizedToFit(_:)` instead.
    */
    func resizedTo(_ newSize: CGSize) -> UIImage {
        if #available(iOSApplicationExtension 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let image = renderer.image { _ in
                self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
            }
            return image

        } else {
            // Fallback on earlier versions

            let newRect = CGRect(origin: .zero, size: newSize).integral
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
                return self
            }
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            guard let img = context.makeImage() else {
                return self
            }
            let newImage = UIImage(cgImage: img)
            UIGraphicsEndImageContext()

            return newImage
        }

    }

    /**
     Resizes the receiver to the largest size that fits within `newSize` all the
     while preserving the receiver's original aspect ratio. Similar to the
     resizing that `UIImageView` does to its content when contentMode is set to
     `.scaleAspectFit`.
     */
    func resizedToFit(_ newSize: CGSize) -> UIImage {
        let currentSize = self.size
        let imageAspect = currentSize.width / currentSize.height
        let targetAspect = newSize.width / newSize.height

        if imageAspect > targetAspect {
            // Image too wide; scale both dimensions by the same factor so that
            // the width fits.
            let factor = newSize.width / currentSize.width
            let correctedSize = currentSize * factor
            return self.resizedTo(correctedSize)
        } else {
            // Image too tall; scale both dimensions by the same factor so that
            // the height fits
            let factor = newSize.height / currentSize.height
            let correctedSize = currentSize * factor
            return self.resizedTo(correctedSize)
        }
    }

    /**
     Initializes an instance as a solid (constant) image of the specified color and size
     */
    convenience init?(color: UIColor?, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        let actualColor = color ?? .clear
        context?.setFillColor(actualColor.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}

// MARK: -

public extension UIImage.Orientation {

    /**
     For identifying each value on the debug console.
     */
    var debugDescription: String {
        switch  self {
        case .up:
            return "Up"
        case .upMirrored:
            return "Up (Mirrored)"
        case .down:
            return "Down"
        case .downMirrored:
            return "Down (Mirrored)"
        case .left:
            return "Left"
        case .leftMirrored:
            return "Left (Mirrored)"
        case .right:
            return "Right"
        case .rightMirrored:
            return "Right (Mirrored)"
        @unknown default:
            fatalError()
        }
    }

    /**
     `UIImage.Orientation` and `CGImagePropertyOrientation` both cover all 8
     possible EXIF orientations (up, down, left, right, and their mirrored
     counterparts). However, the actual enumeration raw values do not match.
     */
    var cgOrientation: CGImagePropertyOrientation {
        switch self {
        case .up:
            return .up
        case .upMirrored:
            return .upMirrored
        case .down:
            return .down
        case .downMirrored:
            return .downMirrored
        case .left:
            return .left
        case .leftMirrored:
            return .leftMirrored
        case .right:
            return .right
        case .rightMirrored:
            return .rightMirrored
        @unknown default:
            fatalError()
        }
    }

    static func == (lhs: UIImage.Orientation, rhs: CGImagePropertyOrientation) -> Bool {
        return (lhs.cgOrientation == rhs)
    }

    static func == (lhs: CGImagePropertyOrientation, rhs: UIImage.Orientation) -> Bool {
        return (lhs == rhs.cgOrientation)
    }
}
