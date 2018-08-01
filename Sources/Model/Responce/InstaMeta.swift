//
//  InstaMeta.swift
//  InstaApp
//
//  Created by Dimasno1 on 7/16/18.
//  Copyright © 2018 dimasno1. All rights reserved.
//
import UIKit
import MapKit

class InstaMeta: NSObject, Decodable {

    let id: String
    let user: User
    let images: [String: Image]
    let createdTime: String
    let caption: Caption?
    let userHasLiked: Bool
    let likes: [String: Int]
    let tags: [String]
    let filter: String
    let comments: [String: Int]
    let type: String
    let link: String
    let location: Location?
    let attribution: String?
    let usersInPhoto: [User]?

    var photoURL: URL? {
        guard let urlString = images["standardResolution"]?.url else {
            return nil
        }

        return URL(string: urlString)
    }

    var likesCount: Int {
        return likes["count"] ?? 0
    }

    var mapAnnotation: MetaMapAnnotation? {
        guard let location = location, let url = photoURL else {
            return nil
        }

        return MetaMapAnnotation(location: location, createdTime: createdTime, photoURL: url)
    }

    var hasLocation: Bool {
        return location != nil
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        user = try container.decode(User.self, forKey: .user)
        images = try container.decode([String: Image].self, forKey: .images)
        createdTime = try container.decode(String.self, forKey: .createdTime)
        caption = try? container.decode(Caption.self, forKey: .caption)
        userHasLiked = try container.decode(Bool.self, forKey: .userHasLiked)
        likes = try container.decode([String: Int].self, forKey: .likes)
        tags = try container.decode([String].self, forKey: .tags)
        filter = try container.decode(String.self, forKey: .filter)
        comments = try container.decode([String: Int].self, forKey: .comments)
        type = try container.decode(String.self, forKey: .type)
        link = try container.decode(String.self, forKey: .link)
        location = try? container.decode(Location.self, forKey: .location)
        attribution = try? container.decode(String.self, forKey: .attribution)
        usersInPhoto = try? container.decode([User].self, forKey: .usersInPhoto)
    }

    enum CodingKeys: String, CodingKey {
        case id, user, images, createdTime, caption, userHasLiked, likes, tags, filter, comments, type, link, location, attribution, usersInPhoto
    }
}

extension InstaMeta {
    struct User: Codable {
        var id: String
        var fullName: String
        var profilePicture: String
        var username: String

        var pictureURL: URL? {
            return URL(string: profilePicture)
        }
    }

    struct Image: Codable {
        var width: Int
        var height: Int
        var url: String
    }

    struct Caption: Codable {
        let id: String
        let text: String
        let createdTime: String
        let from: User
    }

    struct Location: Codable {
        let latitude: Double
        let id: Int
        let longitude: Double
        let name: String
    }
}

enum Either<T, U>: Decodable where T: Decodable, U: Decodable {

    case left(T)
    case right(U)

    init(from decoder: Decoder) throws {
        if let decoded = try? U(from: decoder) {
            self = .right(decoded)
        } else if let decoded = try? T(from: decoder) {
            self = .left(decoded)
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable do decode: \(T.self) and \(U.self)")
            throw DecodingError.dataCorrupted(context)
        }
    }

}

extension InstaMeta {
    var cellCaption: String {
        return caption?.text ?? "No caption"
    }

    var cellTags: [String] {
        return tags.isEmpty ? ["no tags provided"] : tags
    }
}
