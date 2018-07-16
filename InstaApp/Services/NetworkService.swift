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
}

protocol NetworkServiceDelegate: AnyObject {
    func didReceive(_ networkService: NetworkService, data: Data?, with error: Error?)
}

class NetworkService: NSObject {
    
    weak var delegate: NetworkServiceDelegate?
    
    func makeRequest(for url: URL) {
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url)
        
        task.resume()
    }
    
    private var session = URLSession()
}

extension NetworkService: URLSessionDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.delegate?.didReceive(self, data: data, with: nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            if statusCode != 200 {
                self.delegate?.didReceive(self, data: nil, with: NetworkServiceError.invalidResponce)
                completionHandler(.cancel)
            } else {
                completionHandler(.allow)
            }
        }
    }
}
