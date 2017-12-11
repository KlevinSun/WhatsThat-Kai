//
//  MenuViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/22/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  the menu view controller and the first screen of the app, with the camera and favorite function.

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
// the favorite use persistance to achieve
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavos" {
            let favorites = Persistance.shareInstance.fetchWikis()
            let destinationViewController = segue.destination as? FavoritesTableViewController
            destinationViewController?.favoriteWikis = favorites
        }
    }
}
