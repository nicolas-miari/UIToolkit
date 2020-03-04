//
//  UIViewController+Extensions.swift
//  Spotlighter
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

public extension UIViewController {
    /**
     Convenience method to present an alert view (UIAlertController) with a
     specified title, message and (single) dismiss button title, and no actions
     attached (simply informative).
     */
    func presentInformativeAlert(title: String, message: String, dismissButtonTitle: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: nil))
        self.present(alertController, animated: true, completion: completion)
    }
}
