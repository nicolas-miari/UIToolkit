//
//  UIButton+BackgroundColor.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2020/03/05.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import UIKit

public extension UIButton {

    // MARK: - Per-State Background Color

    /**
     Adds support for specifying a custom background color for each control
     state.

     - note: Internally, it just generates a **solid image** of the specified color and from then on it
     delegates to `setBackgroundImage(_:for:)` (extensions cannot declare stored instance properties, so
     it would be impossible to "store" the spearate background colors for each state). Because of this,
     the implementation depends on a separate extension to the `UIImage` class that defines the convenience
     initializer `init(color:size:)`.
     */
    @objc dynamic func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            self.setBackgroundImage(UIImage(color: color), for: state)
        } else {
            self.setBackgroundImage(nil, for: state)
        }
    }

    ///
    @objc dynamic var titleLabelFont: UIFont? {
        get {
            return titleLabel?.font
        }
        set {
            titleLabel?.font = newValue
        }
    }
}
