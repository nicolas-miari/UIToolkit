//
//  AlertViewController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/25.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Implements a custom modal presentation style reminiscent of UIAlertController.
 */
open class AlertViewController: UIViewController {

    ///
    public var horizontalMargin: CGFloat = 30

    ///
    public var verticalMargin: CGFloat = 40

    ///
    override open var preferredContentSize: CGSize {
        set {
        }
        get {
            guard let presentingSize = presentingViewController?.view.bounds.size else {
                return super.preferredContentSize
            }
            let smallest = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let width = min(presentingSize.width, presentingSize.height)
            return CGSize(width: width - 2*horizontalMargin, height: smallest.height)
        }
    }

    // MARK: -

    private static let transitionDelegate = AlertTransitionDelegate()

    // MARK: -

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonSetup()
    }

    private func commonSetup() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = AlertViewController.transitionDelegate
    }
}
