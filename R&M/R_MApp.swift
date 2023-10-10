//
//  R_MApp.swift
//  R&M
//
//  Created by Thais Rodríguez on 4/10/23.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct R_MApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(store: Store(initialState: ListReducer.State()) {
                ListReducer()
            })
        }
    }
}
