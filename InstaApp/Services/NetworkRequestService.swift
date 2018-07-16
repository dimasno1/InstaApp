//
//  NetworkRequestService.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/15/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class NetworkRequestService {
    
    func makeRequest(for purpose: Purpose, with parameters: [EndpointParameter: String]) {
        let endpoint = purpose.endpoint()
        endpoint.setParameters(parameters: parameters)
    }
    
}
