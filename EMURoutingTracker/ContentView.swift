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
    }
}

// MARK: - iOS 16-17 (classic .tabItem)
private struct RootTabs_Legacy: View {
    var body: some View {
        TabView {
            QueryView()
                .tabItem {
                    Image(systemSymbol: .magnifyingglass)
                    Text("查询")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemSymbol: .bookmark)
                    Text("收藏")
                }
            
            AboutView()
                .tabItem {
                    Image(systemSymbol: .info)
                    Text("更多")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
