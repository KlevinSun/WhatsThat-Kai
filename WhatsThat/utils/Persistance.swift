//
//  Persistance.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/3/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  Use UserDefaults.standard to persist the favorite data

import Foundation

class Persistance{
    static let shareInstance = Persistance()
    
    let WikisKey = "WikiFavos"
// fetch saved data from persistance
    func fetchWikis() ->[Wiki] {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: WikisKey) as? Data
        
        if let data = data {
            let wikiArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Wiki] ?? [Wiki]()

            return wikiArray
        }else{
            return [Wiki]()
        }
    }
    
// fetch saved data from persistance, append a new one, then save back
    func saveWikis(_ wiki: Wiki){
        let userDefaults = UserDefaults.standard
        var Wikis = fetchWikis()
        Wikis.append(wiki)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: Wikis)
        userDefaults.set(data, forKey: WikisKey)
    }
}
