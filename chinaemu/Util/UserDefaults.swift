//
//  UserDefaults.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    var favoriteTrains: DefaultsKey<[Favorite]> {.init("favoriteTrains", defaultValue: []) }
    var favoriteEMUs: DefaultsKey<[Favorite]> {.init("favoriteEMUs", defaultValue: []) }
}

struct Favorite: Codable, Hashable, DefaultsSerializable {
    let name: String
    let isPushEnabled: Bool
    
    init(_ name: String) {
        self.name = name
        self.isPushEnabled = false
    }
}
