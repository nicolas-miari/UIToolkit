//
//  MaskedTransitionAnimationController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/13.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Animates the push and pop transitions more or less replicating the default
 behaviout of `UINavigationController`, but clips away the underlapping portions
 of the bottom-most view controller, enabling the use transaprent views without
 artifacts.
 */
class MaskedTransitionAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval = 0.25

    let operation: UINavigationController.Operation

    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            return animatePush(using: transitionContext)
        case .pop:
            return animatePop(using: transitionContext)
        default:
            break
        }
    }

    // MARK: - Operation-Specific Helper Methods (Private)

    private func animatePush(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // Add DESTINATION view to the specified container:
        transitionContext.containerView.addSubview(toView)

        // ...and center it on screen:
        let containerBounds = transitionContext.containerView.bounds
        toView.center = CGPoint(x: containerBounds.midX, y: containerBounds.midY)

        // ...but translate it to fully the RIGHT (starting state):
        toView.transform = CGAffineTransform(translationX: +1.0*containerBounds.width, y: 0)

        // We will slide the SOURCE view out, to the LEFT, by half as much:
        let fromTransform = CGAffineTransform(translationX: -0.5*containerBounds.width, y: 0)

        // Apply a white UIView as mask to the SOURCE view:
        let maskView = UIView(frame: CGRect(origin: .zero, size: fromView.frame.size))
        maskView.backgroundColor = .white
        fromView.mask = maskView

        // The mask will shrink to half the width during the animation:
        let maskViewNewFrame = CGRect(origin: .zero, size: CGSize(width: 0.5*fromView.frame.width, height: fromView.frame.height))

        // Animate:
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.transform = fromTransform // (Halfway off-screen, to the left)
            toView.transform = .identity // (Back on screen, centered)
            maskView.frame = maskViewNewFrame // (Mask to half width)

        }, completion: {(completed) in
            // Remove mask, otherwise funny things will happen if toView is a
            // scroll or table view and the user "rubberbands":
            fromView.mask = nil

            // Flag as done:
            transitionContext.completeTransition(completed)
        })
    }

    private func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }

        // Add the DESTINATION view to the specified container:
        transitionContext.containerView.addSubview(toView)

        // ...and center it on screen:
        let containerBounds = transitionContext.containerView.bounds
        toView.center = CGPoint(x: containerBounds.midX, y: containerBounds.midY)

        // ...but translate it momentarily halfway to the LEFT (starting state):
        toView.transform = CGAffineTransform(translationX: -0.5*containerBounds.width, y: 0)

        // We will slide the SOURCE view out, to the RIGHT, fully. Pre-calculate
        // the transform to do so within the animation:
        let fromTransform = CGAffineTransform(translationX: +1.0*containerBounds.width, y: 0)

        // Apply a white UIView as mask to the DESTINATION view, at the begining
        // revealing only the left-most half:
        let halfWidthSize = CGSize(width: 0.5*toView.frame.width, height: toView.frame.height)
        let maskView = UIView(frame: CGRect(origin: .zero, size: halfWidthSize))
        maskView.backgroundColor = .white
        toView.mask = maskView

        // And calculate a new frame to make it grow back to full width during
        // the animation:
        let maskViewNewFrame = toView.bounds

        // Animate:
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.transform = fromTransform // (Fully off-screen, to the right)
            toView.transform = .identity // (Back on screen, centered)
            maskView.frame = maskViewNewFrame // (Mask back to full width: no clipping)

        }, completion: {(completed) in
            // Remove mask, otherwise funny things will happen if toView is a
            // scroll or table view and the user "rubberbands":
            toView.mask = nil

            // Flag as done:
            transitionContext.completeTransition(completed)
        })
    }
}
