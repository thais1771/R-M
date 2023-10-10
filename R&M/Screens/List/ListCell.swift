//
//  ListCell.swift
//  R&M
//
//  Created by Thais Rodríguez on 6/10/23.
//

import SwiftUI

struct ListCell: View {
    struct DataModel {
        let name: String
        let image: String
        let status: CharacterStatus
    }

    let data: DataModel

    var body: some View {
        HStack(spacing: 5) {
            if let url = data.image.url {
                CacheAsyncImage(url: url,
                                content: { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50, alignment: .center)
                    } else {
                        Image("character_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .grayscale(1)
                            .frame(width: 50, height: 50, alignment: .center)
                    }
                })
                .clipped()
                .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            }
            Text(data.name)
                .font(.title3)
            Spacer()
            LiveStatusView(status: data.status)
        }
    }
}

#Preview {
    ListCell(data: .init(name: "Abradolf Lincler",
                         image: "https://rickandmortyapi.com/api/character/avatar/7.jpeg",
                         status: .Alive))
}
