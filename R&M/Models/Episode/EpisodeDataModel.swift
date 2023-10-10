//
//  EpisodeDataModel.swift
//  R&M
//
//  Created by Thais Rodríguez on 9/10/23.
//

import Foundation

struct EpisodeDataModel: Decodable, Equatable, Identifiable {
    static func == (lhs: EpisodeDataModel, rhs: EpisodeDataModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
}

extension EpisodeDataModel {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)!
        self.name = try values.decodeIfPresent(String.self, forKey: .name)!
        self.air_date = try values.decodeIfPresent(String.self, forKey: .airDate)!
        self.episode = try values.decodeIfPresent(String.self, forKey: .episode)!
        self.characters = try values.decodeIfPresent([String].self, forKey: .characters)!
        self.url = try values.decodeIfPresent(String.self, forKey: .url)!
    }
}
