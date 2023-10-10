//
//  CharactersAPIClient.swift
//  R&M
//
//  Created by Thais Rodríguez on 5/10/23.
//

import Foundation

protocol CharactersAPIClientProtocol {
    func getAll(page: Int) async throws -> CharactersDataModel
    func search(name: String, page: Int) async throws -> CharactersDataModel
}

class CharactersAPIClient: CharactersAPIClientProtocol, HTTPRequest {
    static let shared = CharactersAPIClient()
    
    func getAll(page: Int) async throws -> CharactersDataModel {
        let endpoint = CharactersEndpoint.all(page: page)
        return try await run(endpoint)
    }
    
    func search(name: String, page: Int) async throws -> CharactersDataModel {
        let endpoint = CharactersEndpoint.search(name: name, page: page)
        return try await run(endpoint)
    }
}
