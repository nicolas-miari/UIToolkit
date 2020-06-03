//
//  Transition.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 Defines properties common to all view controllers presented modally ina custom
 fashion.
 */
public protocol ModalPresentationTransitionable {

    var dimmingOpacity: CGFloat { get set }

    var presentationDuration: TimeInterval { get set }

    var dismissalDuration: TimeInterval { get set }

    func transitionDuration(for phase: AnimatedTransitionPhase) -> TimeInterval
}

extension ModalPresentationTransitionable {

    public func transitionDuration(for phase: AnimatedTransitionPhase) -> TimeInterval {
        switch phase {
        case .presentation:
            return presentationDuration
        case .dismissal:
            return dismissalDuration
        }
    }
}

// MARK: - Supporting Types

/**
 Provides sensible default values for each of the property requirements of the
 `ModalPresentationTransitionable` protocol.
 */
public struct ModalPresentationDefaults {

    public static let dimmingOpacity: CGFloat = 0.5

    public static let presentationDuration: TimeInterval = 0.25

    public static let dismissalDuration: TimeInterval = 0.125
}

public enum AnimatedTransitionPhase {
    case presentation
    case dismissal
}
