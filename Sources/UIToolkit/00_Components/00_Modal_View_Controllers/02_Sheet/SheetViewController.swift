//
//  SheetViewController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Implements a custom modal presentation style reminiscent of UIAlertController
 with `.sheet` style.
 */
open class SheetViewController: UIViewController, ModalPresentationTransitionable {

    private static let transitionDelegate = SheetTransitionDelegate()

    // MARK: -

    /**
     Executed once when a tap to dismiss is detected on the dimming view, right
     before the dismissal transition.
     */
    public var dismissHandler: (() -> Void)?

    // MARK: - UIViewController

    override open var preferredContentSize: CGSize {
        set {
        }
        get {
            guard let presentingSize = presentingViewController?.view.bounds.size else {
                return super.preferredContentSize
            }

            self.view.layoutIfNeeded()
            let compressedSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let compressedHeight = compressedSize.height

            return CGSize(width: presentingSize.width, height: compressedHeight)
        }
    }

    // MARK: - ModalPresentable

    public var dimmingOpacity: CGFloat = ModalPresentationDefaults.dimmingOpacity

    public var presentationDuration: TimeInterval = ModalPresentationDefaults.presentationDuration

    public var dismissalDuration: TimeInterval = ModalPresentationDefaults.dismissalDuration

    // MARK: - Initialization

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
        self.transitioningDelegate = SheetViewController.transitionDelegate
    }
}
