//
//  MenuViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/22/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavos" {
            let favorites = Persistance.shareInstance.fetchWikis()
            let destinationViewController = segue.destination as? FavoritesTableViewController
            destinationViewController?.favoriteWikis = favorites
        }
    }
}
