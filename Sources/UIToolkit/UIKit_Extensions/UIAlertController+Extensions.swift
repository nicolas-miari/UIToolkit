//
//  UIAlertController+Extensions.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2019/02/04.
//  Copyright © 2019 Nicolás Miari. All rights reserved.
//

import UIKit

public extension UIAlertController {
    /**
     Convenient shortcut for instantiating a UIAlertAction with the specified
     arguments, and adding it to the rceiver in one go.

     - parameter title: The title of the button associated with the action.
     - parameter style: The style of the button associated with the action.
     - parameter handler: An optional closure executed when the user taps the button associated with the action.
     */
    func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil){
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
}
