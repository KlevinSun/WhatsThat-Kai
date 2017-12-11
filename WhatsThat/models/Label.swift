//
//  Label.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/26/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  A struct of the label get from Google Vision API

import Foundation

struct Label: Decodable{
    let description: String
    let score: Double
    
}
