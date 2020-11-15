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
            MoerailView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
