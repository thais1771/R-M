//
//  LocationAPIClient.swift
//  R&M
//
//  Created by Thais Rodríguez on 8/10/23.
//

import Foundation

protocol LocationAPIClientProtocol {
    func getLocation(_ url: URL) async throws -> LocationDataModel
}

class LocationAPIClient: LocationAPIClientProtocol, HTTPRequest {
    static let shared = LocationAPIClient()

    func getLocation(_ url: URL) async throws -> LocationDataModel {
        let request = URLRequest(url: url)
        return try await run(request)
    }
}
