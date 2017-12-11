//
//  IdentificationViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/28/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  Wiki identification view showing wiki summary, with button to evoke wiki, twitter, share, and favorite

import UIKit
import MBProgressHUD
import SafariServices
import Toast_Swift



class IdentificationViewController: UIViewController {

    @IBOutlet weak var visionLabel: UILabel!
    @IBOutlet weak var WIKISummary: UITextView!
    var label: String = String()
    var directory: String = String()
    @IBOutlet weak var buttonWiki: UIBarButtonItem!
    @IBOutlet weak var buttonTweet: UIBarButtonItem!
    @IBOutlet weak var buttonFavo: UIButton!
    var summary: Wiki?
    // initial a WikiSummaryFinder
    let wikiFinder = WikiSummaryFinder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wikiFinder.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        buttonWiki.isEnabled = false
        buttonTweet.isEnabled = false
        buttonFavo.isEnabled = false
        if(summary == nil){
            // load summary from Wiki API using the label sent to this view
            loadSummary(label: label)
            print("directory: \(directory)")
        }else{
            //if summary already have value, means it come from favorites table view, load information to the view
            MBProgressHUD.hide(for: self.view, animated: true)
            visionLabel.text = summary!.title
            WIKISummary.text = summary!.extract
            WIKISummary.isEditable = false
            buttonWiki.isEnabled = true
            buttonTweet.isEnabled = true
            buttonFavo.isEnabled = false
        }
    }

    func loadSummary(label: String){
        // load Wiki Summary
        wikiFinder.fetchWikiSummary(label: label)
    }
// When WIKI button is clicked, evoke following function
    @IBAction func wikiOnclick(_ sender: Any) {
        // load Wiki page using SafariServices
        showSafari(pageID: (summary?.pageId)!)
    }
// if SHARE button is clicked, evoke following function using UIActivityViewController
    @IBAction func shareOnclick(_ sender: Any) {
        let textToShare = "\(label) is \(String(describing: summary?.extract))!"
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
// if favorite button is clicked, evoke following function using UserDefault to save persistance data in App
    @IBAction func favoriteOnclick(_ sender: Any) {
        if(summary != nil){
            Persistance.shareInstance.saveWikis(summary!)
            self.view.makeToast("Favorite Added! :)")
            
        }else{
            self.view.makeToast("Favorite Add Failed!")
        }
    }
// load Wiki webpage using SafariViewController
    func showSafari(pageID : Int) {
        if let url = URL(string: "https://en.wikipedia.org/?curid=\(pageID)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
// prepare data for Twitter page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destView = segue.destination as? SearchTimelineViewController {
            destView.searchTweet = label
        }
    }
}

extension IdentificationViewController: WikiSummaryDelegate{
    // if Wiki Summary is found successfully, callback following function
    func wikiFound(summary: Summary) {
        // restruct Summary to a Wiki object, add the directory created in the cameraViewController
        self.summary = Wiki(title: summary.title, pageId: summary.PageID, extract: summary.extract, directory: self.directory)
        DispatchQueue.main.async {
            // load data
            MBProgressHUD.hide(for: self.view, animated: true)
            self.visionLabel.text = summary.title
            self.WIKISummary.text = summary.extract
            self.WIKISummary.isEditable = false
            self.buttonWiki.isEnabled = true
            self.buttonTweet.isEnabled = true
            self.buttonFavo.isEnabled = true
        }
    }
    // if Wiki Summary is not found, callback following function, give a alertView with failureReason
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
