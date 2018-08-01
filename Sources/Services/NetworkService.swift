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
    case noDataReceived
    case invalidURL
}

class NetworkService: NSObject {

    typealias Callback = ([InstaMeta]?, Error?) -> Void

    override init() {
        super.init()
    }

    func makeRequest(for searchWord: String, with token: Token, parser: InstaDataParser, callback: @escaping Callback) {
        lastCreatedDataTask?.cancel()

        guard let url = makeURL(for: searchWord, token: token) else {
            callback(nil, NetworkServiceError.invalidURL)
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                callback(nil, NetworkServiceError.noDataReceived)
                return
            }

            do {
                let instaMeta = try parser.parse(data: data)
                callback(instaMeta, nil)
            } catch {
                callback(nil, error)
            }
        }

        lastCreatedDataTask = task
        task.resume()
    }

    private func makeURL(for searchWord: String, token: Token) -> URL? {
        let endpointParameters = [Endpoint.Parameter.count: searchWord]
        let endpoint = Endpoint(purpose: .users, parameters: endpointParameters)
        let endpointConstructor = EndpointConstructor(endpoint: endpoint)

        let url = endpointConstructor.makeURL(with: token, searchWord: searchWord)

        return url
    }

    private var lastCreatedDataTask: URLSessionDataTask?
    private lazy var session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
}
