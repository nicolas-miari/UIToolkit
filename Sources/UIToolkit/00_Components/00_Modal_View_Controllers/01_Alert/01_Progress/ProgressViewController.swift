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
open class ProgressViewController: ModalViewController {

    public let message: String?

    public var textSize: CGFloat = 15

    ///
    public let style: ProgressViewControllerStyle

    ///
    public let layout: ProgressViewControllerLayout

    ///
    private let margin: CGFloat = 24//16

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

        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = AlertTransitionDelegate.shared
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

        view.backgroundColor = .clear
        view.clipsToBounds = true

        // View was created programmatically; disable autoresizing masks:
        self.view.translatesAutoresizingMaskIntoConstraints = false

        // Blur:
        let blurView = blurEffectView(for: style)
        view.insertSubview(blurView, at: 0)
        blurView.pinEdgesToParent()

        // Add all further subviews to this one:
        let contentView = blurView.contentView

        switch layout {
        case .activityIndicatorAlone:
            let indicator = activityIndicatorView(style: style, layout: layout)
            contentView.addSubview(indicator)
            indicator.pinEdgesToParent(insets: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))

        case .activityIndicatorAboveLabel:
            let indicator = activityIndicatorView(style: style, layout: layout)
            contentView.addSubview(indicator)
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

            let label = self.label(text: message ?? "", style: style)
            contentView.addSubview(label)
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
            label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: margin).isActive = true

        case .activityIndicatorLeftOfLabel:
            let indicator = activityIndicatorView(style: style, layout: layout)
            contentView.addSubview(indicator)
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin).isActive = true
            indicator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin).isActive = true

            let label = self.label(text: message ?? "", style: style)
            contentView.addSubview(label)

            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin).isActive = true
            label.leftAnchor.constraint(equalTo: indicator.rightAnchor, constant: margin).isActive = true

        case .progressAboveLabel:
            // WIP...
            let progress = progressView()
            contentView.addSubview(progress)

            let label = self.label(text: message ?? "", style: style)
            contentView.addSubview(label)

            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: progress, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .topMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .leftMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .rightMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottomMargin, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: progress, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .topMargin, multiplier: 1, constant: -8)
            ])

        default:
            break
        }
    }

    override open var preferredContentSize: CGSize {
        set { /* (value ignored - but override is required to be readwrite) */}
        get {
            self.view.layoutIfNeeded()
            return view.frame.size
        }
    }

    // MARK: - Initialization Support

    func blurEffectView(for style: ProgressViewControllerStyle) -> UIVisualEffectView {
        /*
         Tutorial on effect views:
         https://www.raywenderlich.com/178486/uivisualeffectview-tutorial-getting-started
         */
        let blurStyle: UIBlurEffect.Style = {
            switch style {
            case .auto:
                if #available(iOS 13, *) {
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return .dark
                    default:
                        return .extraLight
                    }
                } else {
                    return .extraLight // < 13, no dark mode
                }
            case .darkContent:
                return .extraLight
            case .lightContent:
                return .dark
            }
        }()
        let blurEffect: UIBlurEffect = UIBlurEffect(style: blurStyle)

        /*
         Vibrancy does not work for this type of modal view (it's impossible to
         get enough text contrast with balck blur on black background);
         Don' use it.
         */
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        return blurView
    }

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
        label.font = UIFont.boldSystemFont(ofSize: textSize)
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
            return .lightGray

        case .auto:
            if #available(iOS 13.0, *) {
                /*
                 Use semantic color that automatically adapts to the trait
                 collection's user interface style:
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
