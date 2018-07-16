//
//  Endpoint.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/15/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation


class Endpoint {
    
    init(purpose: Purpose, parameters: [Parameter: String]) {
        self.purpose = purpose
        self.parameters = parameters
    }

    private (set) var purpose: Purpose
    private (set) var parameters: [Parameter: String]
}

extension Endpoint {
    enum Purpose {
        case users
        case comments
        case tags
    }
    
    enum Parameter: String {
        case max_id
        case min_id
        case count
        case max_tag_id
        case min_tag_id
        case access_token
    }
    
}
