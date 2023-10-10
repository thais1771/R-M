//
//  SimpleDataView.swift
//  R&M
//
//  Created by Thais Rodríguez on 8/10/23.
//

import SwiftUI

struct SimpleDataView: View {
    var title: String
    var value: String?
    var description: [String]? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title2)
                .foregroundStyle(.accent)
            if let value {
                Text(value)
                    .font(.body)
            }
            if let description {
                ForEach(description, id: \.self) { description in
                    Text(description)
                        .font(.footnote)
                }
            }
        }
    }
}

#Preview {
    SimpleDataView(title: "Location", value: "Citadel of Ricks", description: ["Earth"])
}
