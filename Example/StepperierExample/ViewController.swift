//
//  ViewController.swift
//  StepperierExample
//
//  Created by David Elsonbaty on 6/20/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit
import Stepperier

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func stepperierValueDidChange(_ stepper: Stepperier) {
        print("Updated value: \(stepper.value)")
    }
}

