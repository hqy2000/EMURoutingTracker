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
        NavigationView {
            List {
                
                Section(header: Text("车次")) {
                    if favoritesData.favoriteTrains.isEmpty {
                        Text("您可以在查询时收藏某一特定车次（如G2），被关注的车次会在这里显示最新的运用信息。").font(.caption)
                    } else {
                        ForEach(favoritesData.favoriteTrains, id: \.self) { emu in
                            GeneralView(emu)
                        }
                    }
                }
                Section(header: Text("动车组"), footer: Text("您也可以在主屏幕上添加“交路查询”小工具，不用打开 App 即可查看收藏列车的交路信息。")) {
                    if favoritesData.favoriteEMUs.isEmpty {
                        Text("您可以在查询时收藏某一特定动车组（如CRH2A2001），被关注的车次会在这里显示最新的运用信息。").font(.caption)
                    } else {
                        ForEach(favoritesData.favoriteEMUs, id: \.self) { emu in
                            GeneralView(emu)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear(perform: {
                self.favoritesData.refresh()
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
        
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
