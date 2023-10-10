//
//  HTTPMethod.swift
//  
//
//  Created by Thais Rodríguez on 11/5/23.
//

import Foundation

public typealias Body = Data
public enum HTTPMethod {
    case GET
    case POST(Body? = nil)
    
    var rawValue: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}
