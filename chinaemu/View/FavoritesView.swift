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
            Section(header: Text("车组"), footer: Text("您可以在查询时收藏某一特定车次（如G2），被关注的车次会在这里显示最新的运用信息。")) {
                ForEach(favoritesData.favoriteEMUs, id: \.self) { emu in
                    GeneralView(emu)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            self.favoritesData.refresh()
        })
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
