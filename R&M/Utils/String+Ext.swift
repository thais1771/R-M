//
//  String+Ext.swift
//  R&M
//
//  Created by Thais Rodríguez on 5/10/23.
//

import Foundation

extension String {
    var url: URL? {
        URL(string: self)
    }
}
