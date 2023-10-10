//
//  LiveStatusView.swift
//  R&M
//
//  Created by Thais Rodríguez on 8/10/23.
//

import SwiftUI

struct LiveStatusView: View {
    var status: CharacterStatus

    var body: some View {
        HStack(spacing: 3) {
            Circle()
                .fill(status.color)
                .frame(width: 5,
                       height: 5)
            Text(status.rawValue.capitalized)
                .font(.subheadline)
        }
    }
}

#Preview {
    LiveStatusView(status: .Alive)
}
