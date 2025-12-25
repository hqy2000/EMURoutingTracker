//
//  ContentView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 18.0, *) {
            RootTabs_Modern()
        } else {
            RootTabs_Legacy()
        }
    }
}

// MARK: - iOS 18+ (supports Tab role: .search)

@available(iOS 18.0, *)
private struct RootTabs_Modern: View {
    enum TabID: Hashable { case query, favorites, about }
    @State private var selection: TabID = .query
    @ObservedObject private var favoritesStore = FavoritesStore.shared
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("查询", systemImage: "magnifyingglass", value: .query, role: .search) {
                QueryView()
            }
            
            Tab("收藏", systemImage: "bookmark", value: .favorites) {
                FavoritesView()
            }
            
            Tab("更多", systemImage: "info", value: .about) {
                AboutView()
            }
        }
        .onAppear {
            selection = favoritesStore.trainFavorites.isEmpty && favoritesStore.emuFavorites.isEmpty ? .query : .favorites
        }
    }
}

// MARK: - iOS 16-17 (classic .tabItem)
private struct RootTabs_Legacy: View {
    enum TabID: Hashable { case query, favorites, about }
    @State private var selection: TabID = .query
    @ObservedObject private var favoritesStore = FavoritesStore.shared
    
    var body: some View {
        TabView(selection: $selection) {
            QueryView()
                .tabItem {
                    Image(systemSymbol: .magnifyingglass)
                    Text("查询")
                }
                .tag(TabID.query)
            
            FavoritesView()
                .tabItem {
                    Image(systemSymbol: .bookmark)
                    Text("收藏")
                }
                .tag(TabID.favorites)
            
            AboutView()
                .tabItem {
                    Image(systemSymbol: .info)
                    Text("更多")
                }
                .tag(TabID.about)
        }
        .onAppear {
            selection = favoritesStore.trainFavorites.isEmpty && favoritesStore.emuFavorites.isEmpty ? .query : .favorites
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
