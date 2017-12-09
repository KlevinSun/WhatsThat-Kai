//
//  Persistance.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/3/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation

class Persistance{
    static let shareInstance = Persistance()
    
    let WikisKey = "WikiFavos"
    
    func fetchWikis() ->[Wiki] {
        let userDefaults = UserDefaults.standard
        
        let data = userDefaults.object(forKey: WikisKey) as? Data
        
        if let data = data {
            var wikiArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Wiki] ?? [Wiki]()
            //for i in wikiArray{
                
                //wikiArray.remove(at: wikiArray.index(of: i)!)
                
            //}
            return wikiArray
        }else{
            return [Wiki]()
        }
    }
    
    func checkExist(_ wiki: Wiki) -> Bool{
        let wikis = fetchWikis()
        return wikis.contains(wiki)
    }
    
    func saveWikis(_ wiki: Wiki){
        let userDefaults = UserDefaults.standard
        var Wikis = fetchWikis()
        Wikis.append(wiki)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: Wikis)
        userDefaults.set(data, forKey: WikisKey)
    }
}
