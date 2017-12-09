//
//  UIImageViewExtension.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/9/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    func getImage(directory: String, contentMode mode: UIViewContentMode = .scaleAspectFit){
        contentMode = mode
        
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(directory)
        do{
            let imageData = try Data(contentsOf: fileURL)
            self.image = UIImage(data: imageData)
        }catch{
            print("Error loading image :(")
        }
    }
}
