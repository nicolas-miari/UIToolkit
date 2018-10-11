//
//  Transition.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import Foundation

/**
 */
internal enum AnimatedTransitionPhase {
    case presenting
    case dismissing
}

protocol AnimatedTransitionable {
    func transitionDuration(for phase: AnimatedTransitionPhase) -> TimeInterval
}
