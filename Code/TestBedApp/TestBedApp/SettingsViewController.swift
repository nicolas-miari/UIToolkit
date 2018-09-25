//
//  SettingsViewController.swift
//  SpotlighterCore
//
//  Created by Nicolás Miari on 2018/09/25.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit
import UIToolkit

public class SettingsViewController: UIViewController {

    @IBOutlet private(set) weak var blurSlider: UISlider!

    @IBOutlet private(set) weak var dimmingSlider: UISlider!

    ///
    public var completionHandler: (() -> Void)?

    // MARK: -

    private let customTransitioningDelegate: AlertTransitionDelegate
    private let horizontalMargin: CGFloat = 30
    private let verticalMargin: CGFloat = 40

    // MARK: - Initialization

    public required init?(coder aDecoder: NSCoder) {
        self.customTransitioningDelegate = AlertTransitionDelegate()
        super.init(coder: aDecoder)
        commonSetup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.customTransitioningDelegate = AlertTransitionDelegate()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonSetup()
    }

    private func commonSetup() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
    }

    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()

        /// ...
        self.view.translatesAutoresizingMaskIntoConstraints = false

        blurSlider.minimumValue = 0
        blurSlider.maximumValue = 100

        dimmingSlider.minimumValue = 0
        dimmingSlider.maximumValue = 1

        let blurRadius: Float = 10.0 //UserDefaults.shared.float(forKey: "blurRadius")
        blurSlider.setValue(blurRadius, animated: false)

        let dimmingIntensity: Float = 0.5 //UserDefaults.shared.float(forKey: "dimmingIntensity")
        dimmingSlider.setValue(dimmingIntensity, animated: false)

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        view.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: .light)
        //let blurEffect = UIBlurEffect(style: .dark)

        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        view.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

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

    // MARK: - Control Actions

    @IBAction func blurSliderChanged(_ sender: UISlider) {
        //UserDefaults.shared.set(sender.value, forKey: "blurRadius")
    }

    @IBAction func dimmingSliderChanged(_ sender: UISlider) {
        //UserDefaults.shared.set(sender.value, forKey: "dimmingIntensity")
    }

    @IBAction func done(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.completionHandler?()
        })
    }
}

