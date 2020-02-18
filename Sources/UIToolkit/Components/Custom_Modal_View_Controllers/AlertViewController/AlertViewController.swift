//
//  AlertViewController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/09/25.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 Implements a custom modal presentation style reminiscent of UIAlertController
 with `.alert` style.
 */
open class AlertViewController: UIViewController, ModalPresentable {

    // MARK: -

    private static let transitionDelegate = AlertTransitionDelegate()

    // MARK: -

    public enum ContentMode {
        /**
         Causes the preferred content size **height** to be calculated compactly
         using `UIView`'s `systemLayoutSizeFitting()` with an argument of
         `.layoutFittingCompressedSize`. The width expands to fill all available
         space minus horizontal margins or the associated `maximumWidth`,
         whichever is smaller.
         */
        case compact(maximumWidth: CGFloat?)

        /**
         Causes preferred content size to fill all available space, minus
         horizontal and vertical margins.
         */
        case expansive

        /**
         Causes the preferred content size **height** to be calculated compactly
         using `UIView`'s `systemLayoutSizeFitting()` with an argument of
         `.layoutFittingCompressedSize`. The width is set to match the height,
         within the limits allowed by the horizontal margin.
         */
        case square
    }

    /**
     The behaviour that determines the value returned by the override
     `UIViewController` property`pereferredContentSize` (and thus determines the
     displayed size of the view). See `ContentMode` for details on each option.
     The default is `.expansive`.
     */
    public var contentMode: ContentMode = .compact(maximumWidth: 320)

    /**
     In Points. Default is 30.
     */
    public var horizontalMargin: CGFloat = 30

    /**
     In Points. Default is 40.
     */
    public var verticalMargin: CGFloat = 40

    /**
     - note: Preferred content height is calculated using `UIView`'s method
     `systemLayoutSizeFitting()` with an argument of `.layoutFittingCompressedSize`.
     The width is
     */

    /**
     Scaling factor of the affine transform applied to the view controller's
     view at the off-screen end of the transitions (i.e., at the beginning of
     presentation and at the end of dismissal).
     The default is 0.8. This means the view controller is transformed from 80%
     to 100% of its actual size during presentation tranisition, and back down
     to 80% when dismissing. Not restricted to less than 1.
    */
    public var offscreenScaleFactor: CGFloat = 0.8 {
        didSet {
            // Implement!
        }
    }

    // MARK: - ModalPresentable

    public var dimmingOpacity: CGFloat = ModalPresentableDefaults.dimmingOpacity

    public var presentationDuration: TimeInterval = ModalPresentableDefaults.presentationDuration

    public var dismissalDuration: TimeInterval = ModalPresentableDefaults.dismissalDuration
    
    // MARK: - UIViewController

    ///
    override open var preferredContentSize: CGSize {
        set {
        }
        get {
            guard let presentingSize = presentingViewController?.view.bounds.size else {
                return super.preferredContentSize
            }

            switch contentMode {
            case .compact(let maximumWidth):
                // Calculate the most compact size possible, and take its height:
                //
                let compressedSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let compressedHeight = compressedSize.height

                let availableWidth = presentingSize.width - 2*horizontalMargin
                let width = min(availableWidth, maximumWidth ?? .infinity)

                return CGSize(width: width, height: compressedHeight)

            case .expansive:
                let availableWidth = presentingSize.width - 2*horizontalMargin
                let availableHeight = presentingSize.height - 2*verticalMargin

                return CGSize(width: availableWidth, height: availableHeight)

            case .square:
                let compressedSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                let compressedHeight = compressedSize.height

                let availableWidth = presentingSize.width - 2*horizontalMargin
                let width = min(availableWidth, compressedHeight)

                return CGSize(width: width, height: compressedHeight)
            }
        }
    }

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
        self.transitioningDelegate = AlertViewController.transitionDelegate
    }
}
