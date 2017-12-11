//
//  UIImageViewExtension.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/9/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  An extension of UIImageView, used to get image from app sliced document storage with a particular directory

import Foundation
import UIKit

extension UIImageView{
    func getImage(directory: String, contentMode mode: UIViewContentMode = .scaleAspectFit){
        contentMode = mode
        // construct a file document path
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(directory)")
        
        do{
            // get the data of the path
            let imageData = try Data(contentsOf: fileURL)
            self.image = UIImage(data: imageData)
        }catch{
            print("Error loading image :(")
        }
    }
}
