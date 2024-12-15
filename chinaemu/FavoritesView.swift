//
//  FavoritesView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesData = FavoritesData()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section(header: Text("车次")) {
                    if favoritesData.favoriteTrains.isEmpty {
                        Text("您可以在查询时选择收藏某一特定车次（例如G2）。收藏后的车次将在这里显示其最新的运用信息。").font(.caption)
                    } else {
                        ForEach(favoritesData.favoriteTrains, id: \.self) { emu in
                            GeneralView(emu: emu, path: $path)
                        }
                    }
                }
                Section(header: Text("动车组"), footer: Text("您也可以在主屏幕上添加“交路查询”小工具，不用打开 App 即可查看收藏列车和动车组的交路信息。")) {
                    if favoritesData.favoriteEMUs.isEmpty {
                        Text("您可以在查询时选择收藏某一特定动车组（例如CRH2A2001）。收藏后的动车组将在这里显示其最新的运用信息。").font(.caption)
                    } else {
                        ForEach(favoritesData.favoriteEMUs, id: \.self) { emu in
                            GeneralView(emu: emu, path: $path)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear(perform: {
                self.favoritesData.refresh()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .queryNavigation(path: $path)
    }
        
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
