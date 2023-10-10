//
//  ListView.swift
//  R&M
//
//  Created by Thais Rodríguez on 4/10/23.
//

import ComposableArchitecture
import SwiftData
import SwiftUI

struct ListView: View {
    let store: StoreOf<ListReducer>
    @State private var searchText = ""

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path,
                                              action: { .path($0) })) {
            WithViewStore(self.store) { $0 } content: { viewStore in
                VStack {
                    if let error = viewStore.error {
                        Text(error)
                    } else if !viewStore.characters.isEmpty {
                        List(viewStore.characters) { ch in
                            ListCell(data: .init(name: ch.name,
                                                 image: ch.image,
                                                 status: ch.status))
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets.RMDefault)
                                .onAppear {
                                    if ch.isLast(at: viewStore.characters) {
                                        viewStore.send(.paginate)
                                    }
                                }
                                .onTapGesture {
                                    viewStore.send(.didTapCharacter(ch))
                                }
                        }
                        .listStyle(.plain)
                    } else {
                        ProgressView {
                            Text("Loading...")
                        }
                    }
                }
                .navigationTitle("Characters")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(state: SearchReducer.State()) {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.loadCharacters)
                }
            }
        } destination: { store in
            SearchView(store: store)
        }
        .sheet(
            store: store.scope(
                state: \.$characterDetailState,
                action: ListReducer.Action.characterSheet)) { store in
            CharacterDetailView(store: store)
        }
    }
}

#Preview {
    ListView(store: Store(initialState: ListReducer.State(characters: [], page: 1)) {
        ListReducer()
    })
}

extension CharacterDataModel {
    func isLast(at array: [CharacterDataModel]) -> Bool {
        array.last == self
    }
}
