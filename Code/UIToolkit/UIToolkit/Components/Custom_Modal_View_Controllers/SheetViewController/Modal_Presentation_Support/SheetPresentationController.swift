//
//  SheetPresentationController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Presents arbitrary view controllers in a maner similar to the stock
 `UIAlertController` with a `.sheet` style: vertically compact, peeks from the
 bottom of the screen while dimming the presenting context slightly.
 */
class SheetPresentationController: UIPresentationController {

    fileprivate var dimmingView: UIView

    // MARK: - UIPresentationController

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else {
            return CGRect.zero
        }

        let preferredSize = presentedViewController.preferredContentSize

        // Whatever the preferred size is, place center horizontally, at the
        // bottom:
        //
        let frame = CGRect(
            x: (containerBounds.width - preferredSize.width)/2,
            y: (containerBounds.height - preferredSize.height),
            width: preferredSize.width,
            height: preferredSize.height)

        return frame
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView(frame: CGRect.zero)

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        if let sheet = presentedViewController as? ModalViewController {
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: sheet.dimmingOpacity)
        } else {
            dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.125)
        }

        dimmingView.translatesAutoresizingMaskIntoConstraints = false

        // Dismiss on background tap:
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(recognizer:)))
        dimmingView.addGestureRecognizer(tap)
    }

    @objc func tapHandler(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let presentedView = presentedView else {
            return
        }

        // Size: Preserve content height, match width of container.
        //
        let newPresentedSize = CGSize(width: size.width, height: presentedView.frame.height)

        // Position: Preserve bottom anchor.
        //
        let newPresentedOrigin = CGPoint(x: 0, y: size.height - presentedView.frame.height)
        let newFrame = CGRect(origin: newPresentedOrigin, size: newPresentedSize)

        coordinator.animate(alongsideTransition: { (_) in
            presentedView.frame = newFrame

        }, completion: {(_) in
        })
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let container = self.containerView else {
            return
        }

        // Style the content view:
        self.presentedView?.layer.shadowColor = UIColor.black.cgColor
        self.presentedView?.layer.shadowRadius = 20
        self.presentedView?.layer.shadowOpacity = 0.3

        // Configure dimming beackground:
        dimmingView.frame = container.frame
        dimmingView.alpha = 0.0
        container.insertSubview(dimmingView, at: 0)

        NSLayoutConstraint.activate([
            dimmingView.leftAnchor.constraint(equalTo: container.leftAnchor),
            dimmingView.rightAnchor.constraint(equalTo: container.rightAnchor),
            dimmingView.topAnchor.constraint(equalTo: container.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView.alpha = 1.0
            }, completion: { (_) in
                // Unused...
            })
        } else {
            dimmingView.alpha = 1.0
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (_) in
                self.dimmingView.alpha = 0.0
            }, completion: { (_) in
                // Unused...
            })
        } else {
            dimmingView.alpha = 0.0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
