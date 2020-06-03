//
//  MaskedNavigationController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/13.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Custom `UINavigationController` subclass that adds support for a clean,
 artifact-free transitioning back and forth between view controllers that have
 transparent views.

 This navigation controller adopts the protocol `UINavigationControllerDelegate`
 and sets itself as its own delegate on initialization, in order to pass custom
 animator objects as needed. If you set the `.delegate` property to anything
 other than `self` (or at least another instance of this class, although that
 doesn't seem a very elegant design), **the functionality will break**.

 - important: Masking functionality relies entirely on **not modifying the**
 `delegate` **property**.

 - todo:
   - Add support for interactive transition.
   - Implement navigation bar title "slide" transition.
 */
public class MaskedNavigationController: UINavigationController {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.delegate = self
    }
}

// MARK: - UINavigationControllerDelegate

extension MaskedNavigationController: UINavigationControllerDelegate {

    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return MaskedTransitionAnimationController(operation: operation)
    }
}
