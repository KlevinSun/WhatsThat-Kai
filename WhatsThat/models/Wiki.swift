//
//  Wiki.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/29/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation

/*struct Wiki {
    let title: String
    let pageId: Int
    let extract: String
}*/

class Wiki: NSObject{
    let title: String
    let pageId: Int
    let extract: String
    
    let titlename = "title"
    let pageIdnum = "pageId"
    let extractcontent = "extract"
    
    init(title: String, pageId: Int, extract: String) {
        self.title = title
        self.pageId = pageId
        self.extract = extract
    }
    
    required init?(coder decoder: NSCoder){
        title = decoder.decodeObject(forKey: titlename) as! String
        pageId = decoder.decodeInteger(forKey: pageIdnum)
        extract = decoder.decodeObject(forKey: extractcontent) as! String
    }
}

extension Wiki: NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titlename)
        aCoder.encode(pageId, forKey: pageIdnum)
        aCoder.encode(extract, forKey: extractcontent)
    }
}
