//
//  SearchView.swift
//  R&M
//
//  Created by Thais Rodríguez on 9/10/23.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    let store: StoreOf<SearchReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if !viewStore.error.isNil {
                    Text(viewStore.error ?? "")
                } else if viewStore.characters.isEmpty {
                    Text("Search your favorite character")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
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
                }
                Spacer()
            }
            .searchable(text: viewStore.binding(get: \.searchText,
                                                send: SearchReducer.Action.searchTextDidChange))
            .onSubmit(of: .search) {
                viewStore.send(.clearData)
                viewStore.send(.search(page: 1))
            }
            .sheet(
                store: store.scope(
                    state: \.$characterDetailState,
                    action: SearchReducer.Action.characterSheet)) { store in
                CharacterDetailView(store: store)
            }
        }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchReducer.State()) {
        SearchReducer()
    })
}
