//
//  ContentView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            TabView {
                QueryView()
                    .tabItem { Text("查询") }
                FavoritesView()
                    .tabItem { Text("收藏") }
            }.navigationTitle("动车组交路查询")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
