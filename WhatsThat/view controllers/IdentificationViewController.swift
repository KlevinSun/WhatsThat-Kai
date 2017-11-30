//
//  IdentificationViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/28/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit
import MBProgressHUD

class IdentificationViewController: UIViewController {

    @IBOutlet weak var visionLabel: UILabel!
    @IBOutlet weak var WIKISummary: UITextView!
    var label: String = String()
    var summary: Wiki?
    let wikiFinder = WikiSummaryFinder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visionLabel.text = label
        print(label)
        wikiFinder.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadSummary(label: label)
        
    }

    func loadSummary(label: String){
        
        wikiFinder.fetchWikiSummary(label: label)
    }

}

extension IdentificationViewController: WikiSummaryDelegate{
    func wikiFound(summary: Wiki) {
        self.summary = summary
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.WIKISummary.text = summary.extract
            self.WIKISummary.isEditable = false
        }
    }
    func wikiNotFound(reason: WikiSummaryFinder.FailureReason) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let alertController = UIAlertController(title: "Fetching failed", message: reason.rawValue, preferredStyle: .alert)
            
            switch reason{
            case .networkRequestFailed:
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    self.loadSummary(label: self.label)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alertController.addAction(retryAction)
                alertController.addAction(cancelAction)
                
            case .badJSONResponse, .noData:
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(okayAction)
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
