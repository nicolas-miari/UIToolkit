//
//  ModalViewController.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit

/**
 - todo: Consider making a protocol, so it can be adopted by (e.g.) subclasses
 of UITableViewController, etc.
 */
open class ModalViewController: UIViewController, AnimatedTransitionable {

    /**
     Default is 0.125.
     */
    public var dimmingOpacity: CGFloat = 0.125

    /**
     Default is 0.125.
     */
    public var presentationDuration: TimeInterval = 0.125

    /**
     Default is 0.125.
     */
    public var dismissalDuration: TimeInterval = 0.125

    // MARK: - AnimatedTransitionable

    func transitionDuration(for phase: AnimatedTransitionPhase) -> TimeInterval {
        switch phase {
        case .presenting:
            return presentationDuration
        case .dismissing:
            return dismissalDuration
        }
    }
}
