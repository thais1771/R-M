//
//  EpisodeAPIClient.swift
//  R&M
//
//  Created by Thais Rodríguez on 9/10/23.
//

import Foundation

protocol EpisodeAPIClientProtocol {
    func get(episode url: URL) async throws -> EpisodeDataModel
    func get(episodes: [String]) async throws -> [EpisodeDataModel]
}

class EpisodeAPIClient: EpisodeAPIClientProtocol, HTTPRequest {
    static let shared = EpisodeAPIClient()

    func get(episode url: URL) async throws -> EpisodeDataModel {
        let request = URLRequest(url: url)
        return try await run(request)
    }

    func get<Model: Decodable>(episodes: [String]) async throws -> Model {
        let endpoint = EpisodeEndpoint.episodes(episodes)
        return try await run(endpoint)
    }
}
