//
//  File.swift
//  
//
//  Created by Nicolás Miari on 2020/06/03.
//

import UIKit

/**
 Base view controller that conforms to `ModalPresentationTransitionable`.
 */
open class ModalViewController: UIViewController, ModalPresentationTransitionable {

    // MARK:- Modal Presentation Transitionable

    open var dimmingOpacity: CGFloat = ModalPresentationDefaults.dimmingOpacity

    open var presentationDuration: TimeInterval = ModalPresentationDefaults.presentationDuration

    open var dismissalDuration: TimeInterval = ModalPresentationDefaults.dismissalDuration

}
