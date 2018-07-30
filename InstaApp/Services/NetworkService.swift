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

protocol NetworkServiceDelegate: AnyObject {
    func didReceive(_ networkService: NetworkService, data: Data?, with error: NetworkServiceError?)
}

class NetworkService: NSObject {
    
    weak var delegate: NetworkServiceDelegate?
    
    func makeRequest(for url: URL) {
        let task = session.dataTask(with: url)
        lastCreatedTaskIdentifier = task.taskIdentifier
        task.resume()
    }
    
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    private var lastCreatedTaskIdentifier: Int = 0
}


extension NetworkService: URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if Environment.isDebug {
            print(downloadTask.taskIdentifier, lastCreatedTaskIdentifier, separator: " <- dataFor TaskID, last created TaskID ->")
        }
        
        guard let data = try? Data(contentsOf: location) else {
            self.delegate?.didReceive(self, data: nil, with: .unableToReadData)
            return
        }
        
        self.delegate?.didReceive(self, data: data, with: nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode

            if statusCode != 200 {
                self.delegate?.didReceive(self, data: nil, with: .invalidResponce)
                completionHandler(.cancel)
            } else {
                dataTask.taskIdentifier == lastCreatedTaskIdentifier ? completionHandler(.becomeDownload) : completionHandler(.cancel)
            }
        }
    }
}

