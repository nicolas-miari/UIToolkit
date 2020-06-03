//
//  ViewController.swift
//  Testbed
//
//  Created by Nicolás Miari on 2020/06/03.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func progress(_ sender: Any) {
        let progress = ProgressViewController(message: "Loading...", layout: .activityIndicatorLeftOfLabel, style: .darkContent)
        present(progress, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

