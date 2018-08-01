//
//  InstaDataParser.swift
//  InstaApp
//
//  Created by Dimasno1 on 8/1/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//

import Foundation

enum InstaDataParserError: Error {
    case unableToParseData
}

class InstaDataParser {

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse(data: Data) throws -> [InstaMeta] {
        var collectedMeta = [InstaMeta]()

        guard let instaResponce = try? decoder.decode(InstaResponce.self, from: data), let instaData = instaResponce.data else {
            throw InstaDataParserError.unableToParseData
        }

        // flatmap, compactmap, reduce, filter
        instaData.forEach { meta in
            switch meta {
            case .left(let photoMeta): collectedMeta.append(photoMeta)
            case .right: break
            }
        }

        return collectedMeta
    }

    private let decoder = JSONDecoder()
}
