//
//  InstaVideoMeta.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class InstaVideoMeta: InstaMeta {

    var videos: [String: Video]?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let videosDecoder = try decoder.container(keyedBy: VideoCodingKeys.self)

        videos = try videosDecoder.decode([String: Video].self, forKey: .videos)
    }

   enum VideoCodingKeys: String, CodingKey {
        case videos
    }
}

struct Video: Codable {
    var width: Int
    var height: Int
    var url: String
    var id: String
}
