//
//  FavoritesView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesData = FavoritesData()
    var body: some View {
        List {
            Section(header: Text("车次")) {
                ForEach(favoritesData.favoriteTrains, id: \.self) { emu in
                    GeneralView(emu)
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
