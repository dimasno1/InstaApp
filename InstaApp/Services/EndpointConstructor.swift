//
//  EndpointConstructor.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class EndpointConstructor {
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
        self.parameters = endpoint.parameters
    }
    
    func makeURL(with token: Token, searchWord: String) -> URL? {
        var urlComponents = URLComponents()
        var urlQueryItems = [URLQueryItem(name: Endpoint.Parameter.access_token.rawValue, value: token)]
        
        urlComponents.scheme = Constant.URLComponent.scheme
        urlComponents.host = Constant.URLComponent.host
        urlComponents.path = Constant.URLComponent.path
        
        switch endpoint.purpose {
        case .users: urlComponents.path.append(Constant.URLComponent.usersPath + Constant.URLComponent.recentMediaPath + "/")
        case .comments: urlComponents.path.append(Constant.URLComponent.commentsPath + searchWord + Constant.URLComponent.commentsParameter)
        case .tags: urlComponents.path.append(Constant.URLComponent.tagsPath + searchWord + Constant.URLComponent.recentMediaPath)
        case .authorize: urlComponents.path = Constant.URLComponent.authorizePath
            urlQueryItems = []
        }
        
        for parameter in parameters {
            let queryItem = URLQueryItem(name: parameter.key.rawValue, value: parameter.value)
            urlQueryItems.append(queryItem)
        }
    
        urlComponents.queryItems = urlQueryItems
        
        return urlComponents.url
    }
    
    private let endpoint: Endpoint
    private let parameters: [Endpoint.Parameter: String]
}

extension EndpointConstructor {
    
    struct Constant {
        struct URLComponent {
            static let scheme = "https"
            static let host = "api.instagram.com"
            static let path = "/v1/"
            static let tagsPath = "tags/"
            static let usersPath = "users/self/"
            static let commentsPath = "media/"
            static let commentsParameter = "/comments"
            static let recentMediaPath = "media/recent"
            static let authorizePath = "/oauth/authorize/"
        }
    }
}
