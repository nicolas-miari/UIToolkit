//
//  UIImageView+Extensions.swift
//  Spotlighter
//
//  Created by Nicolás Miari on 2018/09/21.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit
import CGUtils

public extension UIImageView {
    /**
     Returns the frame (in the coordinate system of the receiver) that
     corresponds to the subregion that is actually occupied by the displayed
     image's pixels (that is, the region excluding the padding areas that
     results from the current content mode).

     - note: Only `UIViewContentMode.scaleAspectFit` is supported at the time.
     */
    var contentFrame: CGRect {
        guard let image = self.image else {
            fatalError("UIImageView.contentBounds: No content.")
        }
        switch contentMode {
        case .scaleAspectFit:

            let viewSize = bounds.size
            let imageSize = image.size

            let viewAspect = viewSize.aspectRatio
            let imageAspect = imageSize.aspectRatio

            if imageAspect > viewAspect {
                // Image is too wide: padding above and below

                // Same WIDTH (and "padded" height):
                let contentWidth = viewSize.width
                let contentHeight = contentWidth / imageAspect

                let contentSize = CGSize(width: contentWidth, height: contentHeight)
                let contentOrigin = CGPoint(x: 0, y: 0.5 * (viewSize.height - contentHeight))

                return CGRect(origin: contentOrigin, size: contentSize)

            } else {
                // Image is too tall: padding left and right

                // Same HEIGHT (and "padded" width):
                let contentHeight = viewSize.height
                let contentWidth = contentHeight * imageAspect

                let contentSize = CGSize(width: contentWidth, height: contentHeight)
                let contentOrigin = CGPoint(x: 0.5 * (viewSize.width - contentWidth), y: 0)

                return CGRect(origin: contentOrigin, size: contentSize)
            }

        // Important: must implement all other modes for correctness (even if
        // not needed right now)
        default:
            fatalError("UIImageView.contentBounds: Unsupported content mode.")
        }
    }

    /**
     Returns a copy of the image being displayed, resized to the **pixel** size
     at which it is actually being displayed due to the value of `contentMode`.

     - note: Only `UIViewContentMode.scaleAspectFit` is supported at the time.
    */
    var imageAtDisplayedSize: UIImage? {
        guard self.image != nil else {
            return nil
        }
        let contentSize = contentFrame.size
        return image?.resizedTo(contentSize)
    }
}
