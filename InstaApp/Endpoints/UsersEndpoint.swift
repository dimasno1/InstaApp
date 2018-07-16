//
//  Users.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/15/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class UsersEndpoint: Endpoint {
    
    var name: String = "Users Endpoint"
    var url = URL(string: "https://api.instagram.com/v1/media/{media-id}/comments?access_token=")
    var parameters: [EndpointParameter: String] = [:]
    
    init(parameters: [EndpointParameter: String] = [:]) {
        self.parameters = parameters
    }
    
    func setParameters(parameters: [EndpointParameter: String]) {
        self.parameters = parameters
    }
}
