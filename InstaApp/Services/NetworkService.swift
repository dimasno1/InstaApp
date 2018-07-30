//
//  NetworkService.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

enum NetworkServiceError: Error {
    case invalidResponce
    case unableToReadData
}


class NetworkService: NSObject {
    
    static let shared = NetworkService()
    
    typealias Callback = (Data?, Error?) -> Void
    
    private override init() {
        super.init()
    }
    
    func makeRequest(for url: URL, callback: @escaping Callback) {
        lastCreatedDataTask?.cancel()
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                
                if response.statusCode == 200 {
                    callback(data, error)
                } else {
                    callback(data, NetworkServiceError.invalidResponce)
                }
            }
        }
        
        lastCreatedDataTask = task
        task.resume()
    }
    
    private lazy var session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    private var lastCreatedDataTask: URLSessionDataTask?
}
