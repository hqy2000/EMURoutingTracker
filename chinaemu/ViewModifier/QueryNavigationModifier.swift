//
//  NavigationDestination.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import SwiftUI

struct QueryNavigationModifier: ViewModifier {
    @Binding var path: NavigationPath

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Query.self) { query in
                switch query {
                case .tickets(let departure, let arrival, let date):
                    LeftTicketsView(path: $path, departure: departure.code, arrival: arrival.code, date: date)
                case .trainOrEmu(let trainOrEmu):
                    MoerailView(query: trainOrEmu, path: $path)
                }
            }
    }
}

extension View {
    func queryNavigation(path: Binding<NavigationPath>) -> some View {
        self.modifier(QueryNavigationModifier(path: path))
    }
}
