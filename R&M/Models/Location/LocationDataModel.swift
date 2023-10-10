//
//  LocationDataModel.swift
//  R&M
//
//  Created by Thais Rodríguez on 8/10/23.
//

import Foundation

struct LocationDataModel: Decodable, Equatable, Identifiable {
    static func == (lhs: LocationDataModel, rhs: LocationDataModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
}
