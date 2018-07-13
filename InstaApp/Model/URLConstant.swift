//
//  ID.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/12/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

struct URLConstant {
    
    static let authorizeURL = "https://api.instagram.com/oauth/authorize/"
    
    struct Key {
        static let ID = "client_id"
        static let redirectURL = "redirect_uri"
        static let  responceType = "response_type"
    }
    
    struct Value {
        static let ID = "abf98819234846b0b8640db839bb86d7"
        static let redirectURL = "http://com.dimasno1.InstaApp"
        static let recponceType = "token"
    }
    
}
