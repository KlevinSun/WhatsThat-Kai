//
//  WikiSummaryFinder.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/29/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation

protocol WikiSummaryDelegate {
    func wikiFound(summary: Wiki)
    func wikiNotFound(reason: WikiSummaryFinder.FailureReason)
}

class WikiSummaryFinder {
    enum FailureReason: String {
        case networkRequestFailed = "Your request failed, please try again."
        case noData = "No data received"
        case badJSONResponse = "Bad JSON response"
    }
    
    var delegate: WikiSummaryDelegate?
    
    func fetchWikiSummary(label: String){
        var urlComponents = URLComponents(string: "https://en.wikipedia.org/w/api.php")!
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "extracts"),
            URLQueryItem(name: "exintro", value: nil),
            URLQueryItem(name: "explaintext", value: nil),
            URLQueryItem(name: "title", value: "\(label)")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self.delegate?.wikiNotFound(reason: .networkRequestFailed)
                return
            }
            
            guard let data = data, let wikiJsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [String:Any]() else{
                self.delegate?.wikiNotFound(reason: .noData)
                return
            }
            
            guard let queryJsonObject = wikiJsonObject["query"] as? [String: Any], let pagesJsonObject = queryJsonObject["pages"] as? [String: [String: Any]] else{
                self.delegate?.wikiNotFound(reason: .badJSONResponse)
                return
            }
            
            
            let details = pagesJsonObject.first?.value
            let pageId = details!["pageid"] as? String ?? ""
            let title = details!["title"] as? String ?? ""
            let extract = details!["extract"] as? String ?? ""
            print("pageID: \(pageId), title: \(title), extract: \(extract.count)")
            let summary = Wiki(title: title, pageId: pageId, extract: extract)
            
            self.delegate?.wikiFound(summary: summary)
        }
        
        task.resume()
    }
        
}

