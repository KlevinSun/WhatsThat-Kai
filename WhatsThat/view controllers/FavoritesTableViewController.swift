//
//  FavoritesTableViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/3/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  Favorite TableView, load Favorite label with image to the TableCell

import UIKit

class FavoritesTableViewController: UITableViewController {
 // get favoriteWikis through the segue from MenuViewController
    var favoriteWikis: [Wiki]!
    var favoriteShowDetail: Wiki?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
// get number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteWikis.count
    }

// load cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell

        let favorite = favoriteWikis[indexPath.row]
        print("this is the directory in favoriteTable: \(favorite.directory!)")
        cell.favoLabe.text = favorite.title
        cell.favoImage.getImage(directory: favorite.directory!)
        
        return cell
    }
// prepare data for next view when select a cell
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        favoriteShowDetail = favoriteWikis[indexPath.row]
        return indexPath
    }
// when a cell is selected, evoke the segue to identificationView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favoriteWikis[indexPath.row].path)
        if(shouldPerformSegue(withIdentifier: "showFavorite", sender: self) == false){
            performSegue(withIdentifier: "showFavorite", sender: self)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return favoriteShowDetail == nil
    }
// prepare the data for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showFavorite"){
            let viewController = segue.destination as! IdentificationViewController
            viewController.summary = favoriteShowDetail
        }
    }

}
