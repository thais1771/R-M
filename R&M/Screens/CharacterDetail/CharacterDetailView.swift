//
//  CharacterDetailView.swift
//  R&M
//
//  Created by Thais Rodríguez on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CharacterDetailView: View {
    let store: StoreOf<CharacterDetailReducer>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            ScrollView {
                ZStack(alignment: .top) {
                    AsyncImage(url: viewStore.character.image.url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .opacity(0.5)
                    } placeholder: {
                        Image("character_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .grayscale(1)
                            .clipped()
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            LiveStatusView(status: viewStore.character.status)
                            Spacer()
                        }
                        Text(viewStore.character.name)
                            .font(.title)
                        Text(viewStore.character.species)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(20)
                }
                VStack(spacing: 10) {
                    if let location = viewStore.location {
                        HStack {
                            SimpleDataView(title: "Location",
                                           value: [location.type.capitalized, location.name].joined(separator: " - "),
                                           description: [location.dimension])
                            Spacer()
                        }
                    }
                    HStack {
                        SimpleDataView(title: "Origin",
                                       value: viewStore.character.origin.name)
                        Spacer()
                    }
                    HStack {
                        SimpleDataView(title: "Episodes",
                                       description: viewStore.episodes.sorted(by: { $0.id < $1.id }).compactMap { episode in
                                           [episode.episode, episode.name].joined(separator: " - ")
                                       })
                        Spacer()
                    }
                }
                .padding(20)
            }.onAppear {
                // Load location
                viewStore.send(.loadLocation)

                // Load episodes
                viewStore.send(.loadEpisodes)
                // or load one by one
                // viewStore.character.episode.forEach { episode in
                // viewStore.send(.loadEpisode(episode))
                // }
            }
        }
    }
}

#Preview {
    CharacterDetailView(
        store: Store(
            initialState: CharacterDetailReducer.State(
                character: CharacterDataModel(id: 2,
                                              name: "Rick Sanchez",
                                              status: .Alive,
                                              species: "Human",
                                              type: "Human",
                                              gender: .Female,
                                              origin: .init(name: "Earth (C-137)",
                                                            url: "https://rickandmortyapi.com/api/location/3"),
                                              location: .init(name: "Citadel of Ricks",
                                                              url: "https://rickandmortyapi.com/api/location/3"),
                                              image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                              episode: [
                                                  "https://rickandmortyapi.com/api/episode/1",
                                                  "https://rickandmortyapi.com/api/episode/2",
                                                  "https://rickandmortyapi.com/api/episode/3",
                                                  "https://rickandmortyapi.com/api/episode/4",
                                                  "https://rickandmortyapi.com/api/episode/5",
                                                  "https://rickandmortyapi.com/api/episode/6",
                                                  "https://rickandmortyapi.com/api/episode/7",
                                                  "https://rickandmortyapi.com/api/episode/8",
                                                  "https://rickandmortyapi.com/api/episode/9",
                                                  "https://rickandmortyapi.com/api/episode/10",
                                                  "https://rickandmortyapi.com/api/episode/11",
                                                  "https://rickandmortyapi.com/api/episode/12",
                                                  "https://rickandmortyapi.com/api/episode/13",
                                                  "https://rickandmortyapi.com/api/episode/14",
                                                  "https://rickandmortyapi.com/api/episode/15",
                                                  "https://rickandmortyapi.com/api/episode/16",
                                                  "https://rickandmortyapi.com/api/episode/17",
                                                  "https://rickandmortyapi.com/api/episode/18",
                                                  "https://rickandmortyapi.com/api/episode/19",
                                                  "https://rickandmortyapi.com/api/episode/20",
                                                  "https://rickandmortyapi.com/api/episode/21"
                                              ]))) {
            CharacterDetailReducer()
        })
}
