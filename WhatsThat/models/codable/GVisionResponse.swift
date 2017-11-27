//
//  GVisionResponse.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/24/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation

struct Root: Codable {
    
    let responses: [Responses]
    
}

struct Responses: Codable {
    
    let labelAnnotations: [LabelAnnotations]
    
}

struct LabelAnnotations: Codable {
    
    let mid: String
    let description: String
    let score: Double
    
}


