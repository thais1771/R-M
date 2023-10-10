//
//  SearchReducer.swift
//  R&M
//
//  Created by Thais Rodríguez on 9/10/23.
//

import ComposableArchitecture
import Foundation

struct SearchReducer: Reducer {
    enum Action {
        // LOADS
        case search(page: Int)
        case didFinishLoadCharacters(characters: [CharacterDataModel], pageLimit: Int)

        // ACTIONS        
        case didTapCharacter(_ character: CharacterDataModel)
        case searchTextDidChange(_ text: String)
        case paginate

        // OTHERS
        case error(error: Error)
        case clearData
        case characterSheet(PresentationAction<CharacterDetailReducer.Action>)
    }

    struct State: Equatable {
        var searchText = ""
        var page: Int = 1
        var pageLimit: Int? = nil
        var error: String? = nil
        var characters: [CharacterDataModel] = []
        var loading: Bool = false
        @PresentationState var characterDetailState: CharacterDetailReducer.State?
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // LOADS
            case .search(let page):
                return .run { [text = state.searchText] send in
                    let result: CharactersDataModel = try await CharactersAPIClient.shared.search(name: text, page: page)
                    await send(.didFinishLoadCharacters(characters: result.results, pageLimit: result.info.pages))
                } catch: { error, send in
                    await send(.error(error: error))
                }
            case .didFinishLoadCharacters(characters: let characters, pageLimit: let pagesLimit):
                state.characters.append(contentsOf: characters)
                state.pageLimit = pagesLimit

            // ACTIONS           
            case .didTapCharacter(let character):
                state.characterDetailState = CharacterDetailReducer.State(character: character)

            case .searchTextDidChange(let text):
                state.searchText = text
            case .paginate:
                if state.page == state.pageLimit { return .none }
                state.page += 1
                return .send(.search(page: state.page))

            // OTHERS
            case .error(let error):
                state.error = error.localizedDescription
            case .clearData:
                state.page = 1
                state.characters = []
                state.pageLimit = nil
            case .characterSheet: break
            }
            return .none
        }
        .ifLet(\.$characterDetailState, action: /Action.characterSheet) {
            CharacterDetailReducer()
        }
    }
}
