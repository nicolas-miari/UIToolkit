//
//  SheetTransitionAnimator.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Animates the transition of view controllers presented using
 `SheetTransitionDelegate`; essentialy mimicking that of the stock
 `UIAlertController` class (with style `.sheet`).
 */
class SheetTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    ///
    private(set) internal var phase: AnimatedTransitionPhase

    /// Consider making globally configurable.
    ///
    public var defaultDuration: TimeInterval {
        switch phase {
        case .presenting:
            return 0.125
        case .dismissing:
            return 0.125
        }
    }

    // MARK: - Initialization

    init(phase: AnimatedTransitionPhase) {
        self.phase = phase
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let target = transitionContext?.viewController(forKey: .to) as? AnimatedTransitionable else {
            return defaultDuration
        }
        return target.transitionDuration(for: phase)
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch phase {
        case .presenting:
            animatePresentation(using: transitionContext)
        case .dismissing:
            animateDismissal(using: transitionContext)
        }
    }

    public func animationEnded(_ transitionCompleted: Bool) {
    }

    // MARK: - Support

    private func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {

        // 1. Obtain necessary views and view controllers:
        //
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // 2. Get the final frame (this is the value returned by the method
        //    finalFrameForViewController: of the presentation controller.
        //
        var toViewFinalFrame = transitionContext.finalFrame(for: toViewController)

        // (Adjust for bottom safe area inset)
        if #available(iOSApplicationExtension 11.0, *) {
            let bottom = transitionContext.containerView.safeAreaInsets.bottom
            toViewFinalFrame.origin.y -= bottom
            toViewFinalFrame.size.height += bottom
        }

        // 3. Set the frame to its final state, but apply an affine transform
        //    that "hides" the view offscreen, below:
        //
        toView.frame = toViewFinalFrame
        toView.transform = CGAffineTransform(translationX: 0, y: toViewFinalFrame.height)

        // 4. Add as a subview of the container view.
        //
        transitionContext.containerView.addSubview(toView)

        // 6. Animate

        let duration: TimeInterval = {
            guard let transitionable = toViewController as? AnimatedTransitionable else {
                return defaultDuration
            }
            return transitionable.transitionDuration(for: phase)
        }()

        //
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            /*
             In your animation block, animate the “to” view to its final
             location in the container view. Set any other properties to their
             final values as well.
             */
            //toView.layoutIfNeeded()
            toView.transform = CGAffineTransform.identity

        }, completion: {(completed) in
            /*
             In the completion block, call the completeTransition: method, and
             perform any other cleanup.
             */
            transitionContext.completeTransition(completed)
        })
    }

    private func animateDismissal(using transitionContext: UIViewControllerContextTransitioning) {

        // 1. Obtain the “from” view (the one being dismissed):
        //
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }

        // 2. Compute the end position of the “from” view. This view belongs to
        //    the presented view controller that is now being dismissed.
        //
        let transform = CGAffineTransform(translationX: 0, y: fromView.frame.height)

        // 3. Add the “to” view as a subview of the container view. During a
        //    presentation, the view belonging to the presenting view controller
        //    is removed when the transition completes. As a result, you must
        //    add that view back to the container during a dismissal operation.
        //
        //    Note: the "to" view is nil if the presenting view wasn't removed
        //    as a result of the presentation (as in the non-fullscreen modal
        //    presentation we are attempting), so make optional:
        //
        if let toView = transitionContext.view(forKey: .to) {
            transitionContext.containerView.insertSubview(toView, at: 0)
        }

        if let sheetViewController = transitionContext.viewController(forKey: .from) as? SheetViewController {
            sheetViewController.dismissHandler?()
        }

        // 4. Animate.
        //

        let duration: TimeInterval = {
            guard let transitionable = transitionContext.viewController(forKey: .from) as? AnimatedTransitionable else {
                return defaultDuration
            }
            return transitionable.transitionDuration(for: phase)
        }()

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            /*
             Animate the “from” view to its final location in the container
             view. Set any other properties to their final values as well.
             */
            fromView.transform = transform

        }, completion: {(completed) in
            /*
             In the completion block, remove the “from” view from your view
             hierarchy and call the completeTransition: method. Perform any
             other cleanup as needed.
             */
            fromView.removeFromSuperview()
            transitionContext.completeTransition(completed)
        })
    }
}
