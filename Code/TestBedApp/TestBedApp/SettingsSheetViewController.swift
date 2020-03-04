//
//  SettingsSheetViewController.swift
//  TestBedApp
//
//  Created by Nicolás Miari on 2018/10/11.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIToolkit

class SettingsSheetViewController: SheetViewController {

    @IBOutlet private(set) weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }

    override var preferredContentSize: CGSize {
        set {
            _ = newValue
        }
        get {
            guard let nav = self.children.first as? UINavigationController else {
                return super.preferredContentSize
            }
            guard let tableViewController = nav.topViewController as? UITableViewController else {
                return super.preferredContentSize
            }
            let barHeight = nav.navigationBar.frame.height
            let rowHeight = tableViewController.tableView.rowHeight
            let numRows = tableViewController.tableView.numberOfRows(inSection: 0)

            return CGSize(
                width: super.preferredContentSize.width,
                height: rowHeight * CGFloat(numRows) + barHeight)
        }
    }
}
