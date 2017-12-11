//
//  GVisionRequest.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/24/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  A codable struct used to build request body of Google Vision Request

import Foundation


struct GVision: Codable {
    
    var requests: [Requests]
    
}

struct Requests: Codable {
    
    var image: Image
    var features: [Features]
    
}

struct Image: Codable {
    
    var content: String
    
}

struct Features: Codable {
    
    var type: String
    var maxResults: Int
    
}

