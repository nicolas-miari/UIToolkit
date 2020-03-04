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

protocol ModalPresentable: AnimatedTransitionable {

    var dimmingOpacity: CGFloat { get set }

    var presentationDuration: TimeInterval { get set }

    var dismissalDuration: TimeInterval { get set }
}

// MARK: - Default Implementations

extension ModalPresentable where Self: UIViewController {
    func transitionDuration(for phase: AnimatedTransitionPhase) -> TimeInterval {
        switch phase {
        case .presenting:
            return presentationDuration
        case .dismissing:
            return dismissalDuration
        }
    }
}

public struct ModalPresentableDefaults {

    public static let dimmingOpacity: CGFloat = 0.5

    public static let presentationDuration: TimeInterval = 0.25

    public static let dismissalDuration: TimeInterval = 0.125
}
