//
//  SearchTimelineViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 12/1/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTimelineViewController: TWTRTimelineViewController  {
    
    var searchTweet: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "\(searchTweet)", apiClient: client)
    }

}
