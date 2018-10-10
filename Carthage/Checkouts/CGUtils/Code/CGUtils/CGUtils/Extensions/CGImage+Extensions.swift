//
//  CGImage+Extensions.swift
//  CGUtils
//
//  Created by Nicolás Miari on 2018/09/21.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import CoreGraphics // CGImage
import Foundation   // URL
import ImageIO      // kCGImage...
import UIKit

public extension CGImage {

    /**
     Creates a new `CGImage` from the contents of the specified URL, at the
     requested (low) resolution. Much less resource intensive than lading the
     full-size image into memory once, and then downsampling it.

     - note: Based on code given in the WWDC 2018 video [Image and Graphics Best Practices](https://developer.apple.com/videos/play/wwdc2018/219/)
     */
    public static func withContentsOf(_ imageURL: URL, downsampledToPointSize pointSize: CGSize, scale: CGFloat) -> CGImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }

        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)
        return downsampledImage
    }
}

public extension CGImagePropertyOrientation {

    var localizedDescription: String {
        switch self {
        case .up:
            return "up"
        case .upMirrored:
            return "up mirrored"
        case .down:
            return "down"
        case .downMirrored:
            return "down mirrored"
        case .left:
            return "left"
        case .leftMirrored:
            return "left mirrored"
        case .right:
            return "right"
        case .rightMirrored:
            return "right mirrored"
        }
    }
}
