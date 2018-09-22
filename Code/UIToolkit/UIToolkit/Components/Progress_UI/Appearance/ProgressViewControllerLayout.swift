//
//  ProgressViewControllerLayout.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/04/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import Foundation

/// Constants specifying the type and relative positioning of the components
/// (subviews)
/// displayed within the interface of a `ProgressViewController` instance.
///
public enum ProgressViewControllerLayout {

    /// A single `UIProgressView` centered on top of the modeal _dimming_ view,
    /// without any actual background.
    ///
    ///case bare

    /// A single `UIProgressView` centered on top of a square background view
    /// with round corners, no text.
    ///
    case progressAlone

    /// `UIProgressView` on top, and message label  beneath it.
    /// Both centered horizontally.
    ///
    case progressAboveLabel

    /// Message label at the top, and `UIProgressView` beneath it.
    /// Both are centered horizontally.
    ///
    case progressUnderLabel

    /// A single `UIActivityIndicatorView` centered on top of the background
    /// view, with no text.
    ///
    case activityIndicatorAlone

    /// `UIActivityIndicatorView` on the left (leading), and message label to its
    /// right. Both are centered vertically.
    ///
    case activityIndicatorLeftOfLabel

    /// `UIActivityIndicator` on top, and message label  beneath it.
    /// Both are centered horizontally.
    ///
    case activityIndicatorAboveLabel
}
