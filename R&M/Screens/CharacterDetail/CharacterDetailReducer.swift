//
//  CharacterDetailReducer.swift
//  R&M
//
//  Created by Thais Rodríguez on 6/10/23.
//

import ComposableArchitecture
import Foundation

struct CharacterDetailReducer: Reducer {
    enum Action {
        // LOADS
        case loadLocation
        case loadEpisode(_ episode: String)
        case loadEpisodes
        case didFinishLoadLocation(_ location: LocationDataModel)
        case didFinishLoadEpisode(_ episode: EpisodeDataModel)
        case didFinishLoadEpisodes(_ episodes: [EpisodeDataModel])
    }

    struct State: Equatable {
        var character: CharacterDataModel
        var location: LocationDataModel? = nil
        var episodes: [EpisodeDataModel] = []
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadLocation:
                guard let url = state.character.location.url.url else { return .none }
                return .run { send in
                    let location = try await LocationAPIClient.shared.getLocation(url)
                    await send(.didFinishLoadLocation(location))
                }
            case .didFinishLoadLocation(let location):
                state.location = location
            case .loadEpisode(let episode):
                return .run { send in
                    guard let url = episode.url else { return }
                    let episode = try await EpisodeAPIClient.shared.get(episode: url)
                    await send(.didFinishLoadEpisode(episode))
                }
            case .didFinishLoadEpisode(let episode):
                state.episodes.append(episode)
            case .loadEpisodes:
                let episodes = state.character.episode.compactMap { $0.replacingOccurrences(of: "https://rickandmortyapi.com/api/episode/", with: "") }
                return .run { send in
                    if episodes.count == 1 {
                        let episode: EpisodeDataModel = try await EpisodeAPIClient.shared.get(episodes: episodes)
                        await send(.didFinishLoadEpisode(episode))
                        return
                    }
                    let episodes: [EpisodeDataModel] = try await EpisodeAPIClient.shared.get(episodes: episodes)
                    await send(.didFinishLoadEpisodes(episodes))
                }
            case .didFinishLoadEpisodes(let episodes):
                state.episodes = episodes
            }
            return .none
        }
    }
}
