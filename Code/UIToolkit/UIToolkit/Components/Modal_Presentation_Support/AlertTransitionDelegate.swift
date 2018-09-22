//
//  AlertTransitionDelegate.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/// Manages the transiiton (presentation and animation) of view controllers
/// that need to be presented modally in a manner that mimicks that of the stock
/// `UIAlertController`: The view controller's main view is presented at
/// less-than-fullscreen size, with rounded corners and a blurred/vibrant
/// effect applied to it, over a dimmed background.
///
/// Any custom view controller that sets an instance of this class as its
/// `modalPresentationStyle` property to `.custom` and assigns an instance of
/// this class to its `transitioningDelegate` property will automatically get a
/// presentation and transition behaviour similar to that of UIKit's stock class
/// `UIAlertController`.
///
/// - warning: The `UIViewController` property `transitioningDelegate` is
/// declared as weak, so the delegate is not retained. The view controller
/// should make sure it isn't prematurely deallocated by other means.
///
class AlertTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive presentation is NOT supported)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive dismissal is NOT supported)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .dismissing)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
