//
//  InstaResponce.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

class InstaResponce: NSObject, Decodable {
    let pagination: [String: String]?
    let data: [Either<InstaMeta, InstaVideoMeta>]?
    let meta: [String: Int]?

    init(pagination: [String: String], data: [Either<InstaMeta, InstaVideoMeta>], meta: [String: Int]) {
        self.pagination = pagination
        self.data = data
        self.meta = meta
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        pagination = try? container.decode([String: String].self, forKey: .pagination)
        meta = try? container.decode([String: Int].self, forKey: .meta)
        data = try? container.decode([Either<InstaMeta, InstaVideoMeta>].self, forKey: .data)
    }

    enum CodingKeys: String, CodingKey {
        case pagination
        case data
        case meta
    }
}
