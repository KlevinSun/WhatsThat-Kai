//
//  VisionLabelFinder.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/26/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  A blackbox class used to get Google Vision data

import Foundation

// define a protocal to callback the result of label detection
protocol VisionLabelDelegate{
    func labelsFound(labels:[Label])
    func labelsNotFound()
}

class VisionLabelFinder {
    var delegate: VisionLabelDelegate?
    
    func fetchVisionLabel(imageStr: String){
        // construct google vision request
        var urlComponents = URLComponents(string: "https://vision.googleapis.com/v1/images:annotate")!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "AIzaSyDuxa733TwvzaGsHCc8r9byU0zTx7fQN3M")]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        // construct json request body using Codable
        let jsonRequestBody = GVision(requests: [Requests(image: Image(content: imageStr) , features: [Features(type: "LABEL_DETECTION", maxResults: 50)])])
        let encoder = JSONEncoder()
        guard let encodedBody = try? encoder.encode(jsonRequestBody) else{ return }
        
        request.httpBody = encodedBody
        // request start
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check whether the request get response successfully
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self.delegate?.labelsNotFound()
                return
            }
            // check whether the data is nil
            guard let data = data else{
                self.delegate?.labelsNotFound()
                return
            }
            // if data is not nil, parse the data using codable
            let decoder = JSONDecoder()
            let decoderRoot = try? decoder.decode(Root.self, from: data)
            // if the the data cannot parse using the codable, means the JSON got is wrong
            guard let root = decoderRoot else {
                self.delegate?.labelsNotFound()
                return
            }
            // if the JSON can be parsed, save the required information in the labelOfVision
            var labelOfVision = [Label]()
            let responses = root.responses
            for response in responses{
                let labels = response.labelAnnotations
                for label in labels{
                    let element = Label(description: label.description, score: label.score)
                    labelOfVision.append(element)
                }
            }
            
            self.delegate?.labelsFound(labels: labelOfVision)
        }
        // resume task, until the response is success
        task.resume()
    }
}
