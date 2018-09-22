//
//  ViewController.swift
//  TestBedApp
//
//  Created by Nicolás Miari on 2018/09/22.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import UIKit
import UIToolkit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func launchProgress(_ sender: Any) {
        let progress = ProgressViewController(layout: .activityIndicatorAlone, style: .darkContent)
        present(progress, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}
