//
//  VisionLabelFinder.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/26/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import Foundation

protocol VisionLabelDelegate{
    func labelsFound(labels:[Label])
    func labelsNotFound()
}

class VisionLabelFinder {
    var delegate: VisionLabelDelegate?
    
    func fetchVisionLabel(imageStr: String){
        var urlComponents = URLComponents(string: "https://vision.googleapis.com/v1/images:annotate")!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: "AIzaSyDuxa733TwvzaGsHCc8r9byU0zTx7fQN3M")]
        let url = urlComponents.url!
        let jsonRequestBody = GVision(requests: [Requests(image: Image(content: imageStr) , features: [Features(type: "LABLE_DETECTION", maxResults: 50)])])
        let encoder = JSONEncoder()
        let encodedBody = try? encoder.encode(jsonRequestBody)
        var request = URLRequest(url: url)
        request.httpBody = encodedBody
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                self.delegate?.labelsNotFound()
                return
            }
            
            guard let data = data else{
                self.delegate?.labelsNotFound()
                return
            }
            
            let decoder = JSONDecoder()
            let decoderRoot = try? decoder.decode(Root.self, from: data)
            guard let root = decoderRoot else {
                self.delegate?.labelsNotFound()
                
                return
            }
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
        task.resume()
    }
}
