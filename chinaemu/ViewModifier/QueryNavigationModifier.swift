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
                case .remainingTickets(let departure, let arrival, let date):
                    DepartureArrivalList(departure: departure.code, arrival: arrival.code, date: date, path: $path)
                case .trainOrEmu(let trainOrEmu):
                    TrainOrEMUView(query: trainOrEmu, path: $path)
                }
            }
    }
}

extension View {
    func queryNavigation(path: Binding<NavigationPath>) -> some View {
        self.modifier(QueryNavigationModifier(path: path))
    }
}
