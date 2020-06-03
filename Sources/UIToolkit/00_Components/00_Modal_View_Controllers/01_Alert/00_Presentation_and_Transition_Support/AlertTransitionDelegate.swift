//
//  File.swift
//  
//
//  Created by Nicolás Miari on 2020/06/02.
//

import UIKit

class AlertTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    static let shared = AlertTransitionDelegate()

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .presentation)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AlertTransitionAnimator(phase: .dismissal)
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
        //return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
