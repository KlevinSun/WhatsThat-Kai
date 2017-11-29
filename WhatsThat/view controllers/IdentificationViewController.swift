//
//  IdentificationViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/28/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit

class IdentificationViewController: UIViewController {

    @IBOutlet weak var visionLabel: UILabel!
    @IBOutlet weak var WIKISummary: UITextView!
    var label: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visionLabel.text = label
        print(label)
        // Do any additional setup after loading the view.
    }

    

}
