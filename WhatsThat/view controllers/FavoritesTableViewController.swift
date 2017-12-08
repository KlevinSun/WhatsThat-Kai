//
//  FavoritesTableViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/3/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var favoriteWikis: [Wiki]!
    var favoriteShowDetail: Wiki?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWikis.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)

        let favorite = favoriteWikis[indexPath.row]
        cell.textLabel?.text = "\(favorite.title)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        favoriteShowDetail = favoriteWikis[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favoriteWikis[indexPath.row].directory)
        if(shouldPerformSegue(withIdentifier: "showFavorite", sender: self) == false){
            performSegue(withIdentifier: "showFavorite", sender: self)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return favoriteShowDetail == nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFavorite"){
            var viewController = segue.destination as! IdentificationViewController
            viewController.summary = favoriteShowDetail
        }
    }

}
