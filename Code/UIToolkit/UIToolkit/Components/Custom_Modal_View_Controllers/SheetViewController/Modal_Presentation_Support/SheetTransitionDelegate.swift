//
//  SheetTransitionDelegate.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 */
class SheetTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive presentation is NOT supported)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive dismissal is NOT supported)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetTransitionAnimator(phase: .presenting)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetTransitionAnimator(phase: .dismissing)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
