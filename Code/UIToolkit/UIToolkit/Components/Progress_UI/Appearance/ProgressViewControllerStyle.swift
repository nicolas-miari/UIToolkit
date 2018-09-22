//
//  ProgressViewControllerStyle.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/04/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/// Constants specifying the overall appearance of a `ProgressViewController`
/// instance
///
public enum ProgressViewControllerStyle {

    /// The background is dark, and the text and icons are light gray.
    ///
    case lightContent

    /// The background is light, and the text and icons are dark gray.
    ///
    case darkContent

    var contentColor: UIColor {
        switch self {
        case .lightContent:
            return UIColor.white

        case .darkContent:
            return UIColor.darkGray
        }
    }
}
