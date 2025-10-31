//
//  FavoriteStarView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI

struct FavoriteButton: View {
    let trainOrEMU: String
    let provider: FavoritesProvider
    @ObservedObject private var store: FavoritesStore.Store = FavoritesStore.shared
    
    init(trainOrEMU: String, provider: FavoritesProvider) {
        self.trainOrEMU = trainOrEMU
        self.provider = provider
    }
    
    var body: some View {
        Button(action: {
            store.toggle(trainOrEMU, provider: provider)
        }, label: {
            if store.contains(trainOrEMU, provider: provider) {
                Image(systemName: "star.fill")
            } else {
                Image(systemName: "star")
            }
        })
        .onAppear {
            store.refresh(provider: provider)
        }
    }
}
