//
//  CharacterDataModel.swift
//  R&M
//
//  Created by Thais Rodríguez on 5/10/23.
//

import Foundation
import SwiftUI

struct CharacterDataModel: Decodable, Equatable, Identifiable {
    static func == (lhs: CharacterDataModel, rhs: CharacterDataModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
}

enum CharacterStatus: String, Decodable {
    case Alive
    case unknown
    case Dead

    var color: Color {
        switch self {
        case .Alive: return Color.green
        case .unknown: return Color.gray
        case .Dead: return Color.red
        }
    }
}

enum CharacterGender: String, Decodable {
    case Male
    case Female
    case Genderless
    case unknown
}

struct CharacterOrigin: Decodable {
    let name: String
    let url: String
}

struct CharacterLocation: Decodable {
    let name: String
    let url: String
}
