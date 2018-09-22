//
//  AlertPresentationController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/// Presents arbitrary view controllers in a maner similar to the stock
/// `UIAlertController`: smaller than full-screen, with the view's corners
/// rounded and a dimmed background underneath.
///
class AlertPresentationController: UIPresentationController {

    fileprivate var dimmingView: UIView

    // MARK: - UIPresentationController

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else {
            return CGRect.zero
        }

        let preferredSize = presentedViewController.preferredContentSize

        let frame = CGRect(
            x: (containerBounds.width - preferredSize.width)/2,
            y: (containerBounds.height - preferredSize.height)/2,
            width: preferredSize.width,
            height: preferredSize.height)

        return frame
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.dimmingView = UIView(frame: CGRect.zero)

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let container = self.containerView else {
            return
        }

        // Style the content view:
        self.presentedView?.layer.cornerRadius = 9
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
