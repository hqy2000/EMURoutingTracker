//
//  FavoriteStarView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI

struct FavoriteButton: View {
    @State var selected: Bool
    let trainOrEMU: String
    let provider: FavoritesProvider
    
    init(trainOrEMU: String, provider: FavoritesProvider) {
        self.trainOrEMU = trainOrEMU
        self.provider = provider
        _selected = State(initialValue: provider.contains(trainOrEMU))
    }
    
    var body: some View {
        Button(action: {
            if !provider.contains(trainOrEMU) {
                provider.add(trainOrEMU)
                selected = true
            } else {
                provider.delete(trainOrEMU)
                selected = false
            }
        }, label: {
            if selected {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
        })
    }
}
