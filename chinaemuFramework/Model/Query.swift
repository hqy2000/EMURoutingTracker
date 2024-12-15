//
//  Query.swift
//  chinaemu
//
//  Created by Qingyang Hu on 12/14/24.
//

import Foundation

enum Query {
    case remainingTickets(depature: Station, arrival: Station, date: Date)
    case trainOrEmu(trainOrEmu: String)
}

extension Query: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .remainingTickets(let departure, let arrival, let date):
            hasher.combine(departure)
            hasher.combine(arrival)
            hasher.combine(date)
        case .trainOrEmu(let trainOrEmu):
            hasher.combine(trainOrEmu)
        }
    }
}
