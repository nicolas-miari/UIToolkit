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
        let progress = ProgressViewController(layout: .activityIndicatorAlone, style: .lightContent)
        //progress.presentationDuration = 0.0625
        //progress.dismissalDuration = 3
        present(progress, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func launchCompactSettings(_ sender: Any) {
        launchSettings(contentMode: .compact(maximumWidth: 320))
    }

    @IBAction func launchExpansiveSettings(_ sender: Any) {
        launchSettings(contentMode: .expansive)
    }

    @IBAction func launchSquareSettings(_ sender: Any) {
        launchSettings(contentMode: .square)
    }

    @IBAction func launchSheetSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SettingsSheet", bundle: nil)
        guard let sheet = storyboard.instantiateInitialViewController() as? SettingsSheetViewController else {
            fatalError("!!!")
        }

        sheet.dismissHandler = {
            print("Dismissing!")
        }
        present(sheet, animated: true, completion: nil)
    }

    private func launchSettings(contentMode: AlertViewController.ContentMode) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let settings = storyboard.instantiateInitialViewController() as? SettingsViewController else {
            fatalError("!!!")
        }
        settings.contentMode = contentMode
        present(settings, animated: true, completion: nil)
    }
}
