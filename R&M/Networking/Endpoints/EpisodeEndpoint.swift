//
//  EpisodeEndpoint.swift
//  R&M
//
//  Created by Thais Rodríguez on 9/10/23.
//

import Foundation

enum EpisodeEndpoint: Endpoint {
    case episodes(_ episodes: [String])
    
    var apiKey: String? { nil }
    
    var path: String {
        let baseURLParam = "/api"
        
        switch self {
        case .episodes(let episodes):
            return [baseURLParam, "episode", episodes.joined(separator: ",")].joined(separator: "/")
        }
    }
    
    var pathParams: [String: String]? {
        switch self {
        case .episodes:
            return nil
        }
    }
    
    var headerParams: [String: String]? { nil }
    
    var method: HTTPMethod { .GET }
    
    var scheme: String { "https" }
    
    var host: String { "rickandmortyapi.com" }
}
