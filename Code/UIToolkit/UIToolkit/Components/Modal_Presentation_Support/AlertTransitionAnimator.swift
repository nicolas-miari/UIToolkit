//
//  AlertTransitionAnimator.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/// Animates the transition of view controllers presented using
/// `AlertTransitionDelegate`; essentialy mimicking that of the stock
/// `UIAlertController`
///
///
class AlertTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    ///
    enum Phase {
        case presenting
        case dismissing
    }

    ///
    private(set) public var phase: Phase

    /// Consider making globally configurable.
    ///
    public var duration: TimeInterval {
        switch phase {
        case .presenting:
            return 0.25
        case .dismissing:
            return 0.125
        }
    }

    public var scalingFactor: CGFloat = 0.85

    // MARK: - Initialization

    init(phase: Phase) {
        self.phase = phase
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch phase {
        case .presenting:
            animatePresentation(using: transitionContext)
        case .dismissing:
            animateDismissal(using: transitionContext)
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {

    }

    // MARK: - Support

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        // (Comments taken from steps in the documentation:
        // https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html#//apple_ref/doc/uid/TP40007457-CH16-SW1)

        // 1. Use the viewControllerForKey: and viewForKey: methods to retrieve
        //    the view controllers and views involved in the transition:
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // 2. Set the starting position of the “to” view. Set any other
        //    properties to their starting values as well.
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        let containerBounds = transitionContext.containerView.bounds

        toView.frame = toViewFinalFrame
        toView.center = CGPoint(x: containerBounds.midX, y: containerBounds.midY)
        toView.alpha = 0.0
        toView.transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)

        // 3. Get the end position of the “to” view from the
        //    finalFrameForViewController: method of the context transitioning
        //    context.

        // 4. Add the “to” view as a subview of the container view.
        transitionContext.containerView.addSubview(toView)

        toView.widthAnchor.constraint(equalToConstant: toViewFinalFrame.width).isActive = true
        toView.heightAnchor.constraint(equalToConstant: toViewFinalFrame.height).isActive = true
        toView.centerXAnchor.constraint(equalTo: transitionContext.containerView.centerXAnchor).isActive = true
        toView.centerYAnchor.constraint(equalTo: transitionContext.containerView.centerYAnchor).isActive = true

        // 5. Create the animations.
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            // In your animation block, animate the “to” view to its final
            // location in the container view. Set any other properties to their
            // final values as well.

            toView.transform = CGAffineTransform.identity
            toView.alpha = 1.0
        }, completion: {(completed) in
            // In the completion block, call the completeTransition: method, and
            // perform any other cleanup.

            transitionContext.completeTransition(completed)
        })
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {
        // (Comments taken from steps in the documentation:
        // https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html#//apple_ref/doc/uid/TP40007457-CH16-SW1)

        // 1. Use the viewControllerForKey: and viewForKey: methods to retrieve
        //    the view controllers and views involved in the transition.
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        // 2. Compute the end position of the “from” view. This view belongs to
        //    the presented view controller that is now being dismissed.

        // 3. Add the “to” view as a subview of the container view. During a
        //    presentation, the view belonging to the presenting view controller
        //    is removed when the transition completes. As a result, you must
        //    add that view back to the container during a dismissal operation.

        // Note: the "to" view is nil if the presenting view wasn't removed as
        // a result of the presentation (as in thge non-fullscreen modal
        // presentation we are attempting), so make optional:
        if let toView = transitionContext.view(forKey: .to) {
            transitionContext.containerView.insertSubview(toView, at: 0)
        }

        // 4. Create the animations.
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            // In your animation block, animate the “from” view to its final
            // location in the container view. Set any other properties to their
            // final values as well.

            fromView.transform = CGAffineTransform(scaleX: self.scalingFactor, y: self.scalingFactor)
            fromView.alpha = 0.0

        }, completion: {(completed) in
            // In the completion block, remove the “from” view from your view
            // hierarchy and call the completeTransition: method. Perform any
            // other cleanup as needed.

            fromView.removeFromSuperview()

            transitionContext.completeTransition(completed)
        })
    }
}
