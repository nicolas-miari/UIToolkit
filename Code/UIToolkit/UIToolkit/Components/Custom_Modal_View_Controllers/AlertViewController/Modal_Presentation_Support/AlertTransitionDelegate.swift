//
//  AlertTransitionDelegate.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit
/**
 Manages the transiiton (presentation and animation) of view controllers that
 need to be presented modally in a manner that mimicks that of the stock
 `UIAlertController` with the style set to `.alert.`: The view controller's main
 view is presented at less-than-fullscreen size, with rounded corners and a
 blurred/vibrant effect applied to it, over an overlay background that dims the
 presenting view controller's view.

 Any custom view controller that sets the value of its `modalPresentationStyle`
 property to `.custom` **and** assigns an instance of this class to its
 `transitioningDelegate` property will automatically get a presentation and
 transition behaviour similar to that of UIKit's stock class
 `UIAlertController` (with style `.alert`, _not_ `.actionSheet`).

 - warning: The `UIViewController` property `transitioningDelegate` is
 declared as weak, so the delegate is not retained. The view controller
 should make sure it isn't prematurely deallocated by other means.
*/
public class AlertTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive presentation is NOT supported)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil // (Interactive dismissal is NOT supported)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .presenting)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .dismissing)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
