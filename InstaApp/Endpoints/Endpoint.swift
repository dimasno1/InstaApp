//
//  Endpoint.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/15/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

protocol Endpoint {
    var url: URL? { get }
    var name: String { get }
    var parameters: [EndpointParameter: String] { get }
    
    func setParameters(parameters: [EndpointParameter: String])
}

enum EndpointParameter: String {
    case max_id
    case min_id
    case count
    case lat
    case lng
    case distance
    case max_tag_id
    case min_tag_id
    case facebook_places_id
}

enum Purpose {
    case users
    case media
    case comments
    case tags
    case locations
    
    func endpoint() -> Endpoint {
        switch self {
//        case .comments: return
//        case .locations: return URL(string: "https://api.instagram.com/v1/locations/{location-id}/media/recent?access_token=")
//        case .media: return URL(string: "https://api.instagram.com/v1/media/search?lat=48.858844&lng=2.294351&access_token=")
//        case .tags: return URL(string: "https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=")
        case .users: return UsersEndpoint()
        default: return UsersEndpoint()
        }
    }
    
    func parameters() -> [EndpointParameter] {
        switch self {
        case .comments: return []
        case .locations: return [.lat, .lng, .distance, .facebook_places_id]
        case .media: return [.lat, .lng]
        case .tags: return [.max_tag_id, .min_tag_id, .count]
        case .users: return [.max_id, .min_id, .count]
        }
    }
}
