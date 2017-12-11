//
//  Wiki.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/29/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  A class used to save Wiki summary data and favorite persistance

import Foundation

class Wiki: NSObject{
    let title: String
    let pageId: Int
    let extract: String
    let directory: String?
    
    let titlename = "title"
    let pageIdnum = "pageId"
    let extractcontent = "extract"
    let path = "directory"
    
    init(title: String, pageId: Int, extract: String, directory: String) {
        self.title = title
        self.pageId = pageId
        self.extract = extract
        self.directory = directory
    }
    

    
    required init?(coder decoder: NSCoder){
        title = decoder.decodeObject(forKey: titlename) as! String
        pageId = decoder.decodeInteger(forKey: pageIdnum)
        extract = decoder.decodeObject(forKey: extractcontent) as! String
        directory = decoder.decodeObject(forKey: path) as? String
    }
}

extension Wiki: NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titlename)
        aCoder.encode(pageId, forKey: pageIdnum)
        aCoder.encode(extract, forKey: extractcontent)
        aCoder.encode(directory, forKey: path)
    }
}
