//
//  List.swift
//  R&M
//
//  Created by Thais Rodríguez on 4/10/23.
//

import ComposableArchitecture
import Foundation

struct ListReducer: Reducer {
    enum Action {
        // LOADS
        case loadCharacters
        case didFinishLoadCharacters(characters: [CharacterDataModel], pageLimit: Int)
        
        // ACTIONS
        case didTapCharacter(_ character: CharacterDataModel)
        case paginate
        
        // OTHERS
        case error(error: Error)
        case characterSheet(PresentationAction<CharacterDetailReducer.Action>)
        case path(StackAction<SearchReducer.State, SearchReducer.Action>)
    }
    
    struct State: Equatable {
        var characters: [CharacterDataModel] = []
        var page: Int = 1
        var pageLimit: Int? = nil
        var error: String? = nil
        var searchText: String = ""
        var path = StackState<SearchReducer.State>()
        @PresentationState var characterDetailState: CharacterDetailReducer.State?
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // LOADS
            case .loadCharacters:
                return .run { [page = state.page] send in
                    let result: CharactersDataModel = try await CharactersAPIClient.shared.getAll(page: page)
                    await send(.didFinishLoadCharacters(characters: result.results, pageLimit: result.info.pages))
                } catch: { error, send in
                    await send(.error(error: error))
                }
            case .didFinishLoadCharacters(let characters, let pagesLimit):
                state.characters.append(contentsOf: characters)
                state.pageLimit = pagesLimit
                
            // ACTIONS
            case .didTapCharacter(let character):
                state.characterDetailState = CharacterDetailReducer.State(character: character)
            case .paginate:
                if state.page == state.pageLimit { return .none }
                state.page += 1
                return .send(.loadCharacters)
                
            // OTHERS
            case .error(error: let error):
                state.error = error.localizedDescription
            case .characterSheet: break
            case .path: break
            }
            return .none
        }
        .ifLet(\.$characterDetailState, action: /Action.characterSheet) {
            CharacterDetailReducer()
        }
        .forEach(\.path, action: /Action.path) {
            SearchReducer()
        }
    }
}
