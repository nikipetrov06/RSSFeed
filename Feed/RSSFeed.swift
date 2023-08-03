//
//  RSSFeed.swift
//  RSSFeed
//
//  Created by Nikolay Petrov on 01/08/2023.
//

import Foundation

struct RSSFeed: Decodable {
    let channel: Channel
}

struct Channel: Decodable {
    let title: String
    let description: String
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case items = "item"
    }
}

struct Item: Decodable {
    let title: String
    let link: URL
    let description: String
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case description
        case mediaContent = "media:content"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        link = try container.decode(URL.self, forKey: .link)
        description = try container.decode(String.self, forKey: .description)
        imageURL = try container.decodeIfPresent(MediaContent.self, forKey: .mediaContent)?.url
    }
}

struct MediaContent: Decodable {
    var url: String
    
    enum CodingKeys: CodingKey {
        case url
    }
}
