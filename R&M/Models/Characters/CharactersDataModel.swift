//
//  CharactersDataModel.swift
//  R&M
//
//  Created by Thais Rodríguez on 5/10/23.
//

import Foundation

struct CharactersDataModel: Decodable {
    let info: CharactersInfoDataModel
    let results: [CharacterDataModel]
}

struct CharactersInfoDataModel: Decodable {
    let pages: Int
}
