//
//  ContentView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            QueryView()
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                        Text("查询")
                    }
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "bookmark")
                    Text("收藏")
                }
            AboutView()
                .tabItem {
                    Image(systemName: "info")
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
