//
//  File.swift
//  
//
//  Created by Nicolás Miari on 2020/02/19.
//

import UIKit

extension UIView {
    /**
     If no superview is set, it fails silently.
     */
    func pinEdgesToParent(insets: UIEdgeInsets = .zero) {
        guard let parent = self.superview else {
            return
        }
        self.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left).isActive = true
        self.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -insets.right).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom).isActive = true
    }
}
