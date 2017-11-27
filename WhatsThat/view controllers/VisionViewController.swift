//
//  VisionViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/26/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit
import MBProgressHUD

class VisionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var imageStr: String = String()
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var labels = [Label]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelFinder = VisionLabelFinder()
        if(imageStr == ""){
            let alert = UIAlertController(title: "Warning", message: "Did not select image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            labelFinder.delegate = self
            MBProgressHUD.showAdded(to: self.view, animated: true)
            labelFinder.fetchVisionLabel(imageStr: imageStr)
        }
        
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
        let label = labels[indexPath.row]
        cell.visionLabel.text = label.description
        cell.labelScore.text = String(label.score)
        
        return cell
    }
}

extension VisionViewController: VisionLabelDelegate {
    func labelsFound(labels: [Label]) {
        self.labels = labels
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func labelsNotFound() {
        print("no labels found")
    }
}


    


