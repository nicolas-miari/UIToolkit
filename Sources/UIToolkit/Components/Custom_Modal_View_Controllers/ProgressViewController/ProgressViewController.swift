//
//  ProgressViewController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/04/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 To use, simply present modally like any other view controller (e.g. `UIAlertController`). Custom modal
 presentation is provided by supporting classes.
 */
open class ProgressViewController: UIViewController {
    /*
     Because `UIViewController.transitioningDelegate` is a **weak** property,
     we need this additional reference to hold to it strongly and prevent
     premature deallocation.

     Alternatives would be:
       1. Making the delegate a singleton (bad!), or
       2. Making the view controller adopt the protocol and double as its own transition delegate (inelegant?)
     */
    // swiftlint:disable weak_delegate
    private let customTransitioningDelegate: AlertTransitionDelegate
    // swiftlint:enable weak_delegate

    public let message: String?

    ///
    public let style: ProgressViewControllerStyle

    ///
    public let layout: ProgressViewControllerLayout

    private let margin: CGFloat = 16

    // MARK: - Initialization

    /**
     All arguments have sensible defaults.
     */
    required public init(
        message: String? = nil,
        layout: ProgressViewControllerLayout = .activityIndicatorAlone,
        style: ProgressViewControllerStyle = .auto) {

        self.message = message

        if message == nil {
            switch layout {
            case .activityIndicatorAboveLabel, .activityIndicatorLeftOfLabel:
                self.layout = .activityIndicatorAlone

            case .progressAboveLabel, .progressUnderLabel:
                self.layout = .progressAlone
            default:
                self.layout = layout
            }
        } else {
            self.layout = layout
        }

        self.style = style

        self.customTransitioningDelegate = AlertTransitionDelegate()

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) is unsupported. Use init(message:layout:style) instead.")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is unsupported. Use init(message:layout:style) instead.")
    }

    // MARK: - UIViewController

    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // View was created programmatically; disable autoresizing masks:
        self.view.translatesAutoresizingMaskIntoConstraints = false

        switch style {
        case .darkContent:
            view.backgroundColor = .white
        case .lightContent:
            view.backgroundColor = .black

        case .auto:
            if #available(iOS 13, *) {
                view.backgroundColor = UIColor.systemBackground
            } else {
                view.backgroundColor = .white
            }
        }
        view.backgroundColor = .clear
        view.clipsToBounds = true

        // Tutorial on effect views:
        // https://www.raywenderlich.com/178486/uivisualeffectview-tutorial-getting-started

        let blurEffect: UIBlurEffect = {
            switch style {
            case .darkContent:
                return UIBlurEffect(style: .extraLight)
            case .lightContent:
                return UIBlurEffect(style: .dark)

            case .auto:
                if #available(iOS 13, *) {
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return UIBlurEffect(style: .dark)
                    case .light, .unspecified:
                        return UIBlurEffect(style: .extraLight)
                    @unknown default:
                        return UIBlurEffect(style: .extraLight)
                    }
                } else {
                    return UIBlurEffect(style: .extraLight)
                }
            }
        }()

        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        switch layout {
        case .activityIndicatorAlone:
            let indicator = activityIndicatorView(style: style, layout: layout)
            blurView.contentView.addSubview(indicator)

            indicator.startAnimating()

            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: blurView.contentView, attribute: .topMargin, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: indicator, attribute: .left, relatedBy: .equal, toItem: blurView.contentView, attribute: .leftMargin, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: blurView.contentView, attribute: .bottomMargin, multiplier: 1, constant: -margin),
                NSLayoutConstraint(item: indicator, attribute: .right, relatedBy: .equal, toItem: blurView.contentView, attribute: .rightMargin, multiplier: 1, constant: -margin)
            ])

        case .activityIndicatorAboveLabel:
            let indicator = activityIndicatorView(style: style, layout: layout)
            blurView.contentView.addSubview(indicator)

            let label = self.label(text: message ?? "", style: style)
            blurView.contentView.addSubview(label)

            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: blurView.contentView, attribute: .topMargin, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: blurView.contentView, attribute: .centerX, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: blurView.contentView, attribute: .leftMargin, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: blurView.contentView, attribute: .rightMargin, multiplier: 1, constant: -margin),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: blurView.contentView, attribute: .bottomMargin, multiplier: 1, constant: -margin),

                NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .topMargin, multiplier: 1, constant: -margin)
            ])

        case .activityIndicatorLeftOfLabel:
            let indicator = activityIndicatorView(style: style, layout: layout)
            blurView.contentView.addSubview(indicator)

            let label = self.label(text: message ?? "", style: style)
            blurView.contentView.addSubview(label)

            NSLayoutConstraint.activate([

                NSLayoutConstraint(item: indicator, attribute: .top, relatedBy: .equal, toItem: blurView.contentView, attribute: .topMargin, multiplier: 1, constant: margin),
                NSLayoutConstraint(item: indicator, attribute: .bottom, relatedBy: .equal, toItem: blurView.contentView, attribute: .bottomMargin, multiplier: 1, constant: -margin),
                NSLayoutConstraint(item: indicator, attribute: .left, relatedBy: .equal, toItem: blurView.contentView, attribute: .leftMargin, multiplier: 1, constant: margin),

                NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: blurView.contentView, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: blurView.contentView, attribute: .rightMargin, multiplier: 1, constant: -margin),

                NSLayoutConstraint(item: indicator, attribute: .right, relatedBy: .equal, toItem: label, attribute: .left, multiplier: 1, constant: -margin)
            ])

        case .progressAboveLabel:
            // WIP...
            let progress = progressView()
            blurView.contentView.addSubview(progress)

            let label = self.label(text: message ?? "", style: style)
            blurView.contentView.addSubview(label)

            NSLayoutConstraint.activate([

                NSLayoutConstraint(item: progress, attribute: .top, relatedBy: .equal, toItem: blurView.contentView, attribute: .topMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: blurView.contentView, attribute: .centerX, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: blurView.contentView, attribute: .leftMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: blurView.contentView, attribute: .rightMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: blurView.contentView, attribute: .bottomMargin, multiplier: 1, constant: 0),

                NSLayoutConstraint(item: progress, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .topMargin, multiplier: 1, constant: -8)
            ])

        default:
            break
        }
    }

    override open var preferredContentSize: CGSize {
        set {
        }
        get {
            self.view.layoutIfNeeded()
            return view.frame.size
        }
    }

    // MARK: - Initialization Support

    func progressView() -> UIProgressView {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }

    func activityIndicatorView(style: ProgressViewControllerStyle, layout: ProgressViewControllerLayout) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = contentColor
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }

    func label(text: String, style: ProgressViewControllerStyle) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = contentColor
        label.text = text
        label.sizeToFit()

        return label
    }

    private var contentColor: UIColor {
        switch style {
        case .darkContent:
            return .darkGray

        case .lightContent:
            return .white

        case .auto:
            if #available(iOS 13.0, *) {
                /*
                 Use semantic color that automatically adapts to the trait collection's
                 user interface style:
                 */
                return UIColor.label
            } else {
                /*
                 Assume light mode always (same as .darkContent):
                 */
                return .darkGray
            }
        }
    }
}
