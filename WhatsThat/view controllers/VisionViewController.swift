//
//  VisionViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/26/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  Google vision image Label detect view, this view have half image and half tableView, image come from the former view segue

import UIKit
import MBProgressHUD

class VisionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var imageStr: String = String()
    var image: UIImage = UIImage()
    var directory: String = String()
    var cellselected: String?
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var labels = [Label]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// if the base64 encoded imageStr sent failed, give a alertview; else, fetchVisionLabel use the imageStr
        let labelFinder = VisionLabelFinder()
        if(imageStr == ""){
            let alert = UIAlertController(title: "Warning", message: "Did not select an image for detect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            labelFinder.delegate = self
            MBProgressHUD.showAdded(to: self.view, animated: true)
            labelFinder.fetchVisionLabel(imageStr: imageStr)
        }
    }
// get the table view rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
// load label information: label name and label likelihood score
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelTableViewCell
        let label = labels[indexPath.row]
        cell.visionLabel.text = label.description
        cell.labelScore.text = String(label.score)
        
        return cell
    }
// when select a cell, prepare the data for next view
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let index = indexPath
        let currentCell = labels[index.row]
        cellselected = currentCell.description
        return indexPath
    }
// when a cell is selected, envoke a segue to Wiki identification view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (shouldPerformSegue(withIdentifier: "toWiki", sender: self) == false){
            performSegue(withIdentifier: "toWiki", sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return cellselected == nil
    }
// prepare the data for segue to send
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toWiki"){
            let viewController = segue.destination as! IdentificationViewController
            viewController.label = cellselected ?? ""
            viewController.directory = directory
        }
    }
    
    
}

extension VisionViewController: VisionLabelDelegate {
// if google vision found labels of image, callback following function
    func labelsFound(labels: [Label]) {
        self.labels = labels
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showImage.image = self.image
            self.tableView.reloadData()
        }
    }
// if google vision didn't found labels of image, callback following function
    func labelsNotFound() {
        print("no labels found")
    }
}


    


