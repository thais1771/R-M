//
//  CharactersEndpoint.swift
//  R&M
//
//  Created by Thais Rodríguez on 5/10/23.
//

import Foundation

enum CharactersEndpoint: Endpoint {
    case all(page: Int)
    case search(name: String, page: Int)
    
    var apiKey: String? { nil }
    
    var path: String {
        let baseURLParam = "/api"
        
        switch self {
        case .all, .search:
            return [baseURLParam, "character"].joined(separator: "/")
        }
    }
    
    var pathParams: [String: String]? {
        switch self {
        case .all(let page):
            return ["page": page.string]
        case .search(let name, let page):
            return ["name": name,
                    "page": page.string]
        }
    }
    
    var headerParams: [String: String]? { nil }
    
    var method: HTTPMethod { .GET }
    
    var scheme: String { "https" }
    
    var host: String { "rickandmortyapi.com" }
}
