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
    var lastDeparture: DefaultsKey<Station>{.init("lastDeparture", defaultValue: Station(name: "北京", code: "BJP", pinyin: "beijing", abbreviation: "bj")) }
    var lastArrival: DefaultsKey<Station>{.init("lastArrival", defaultValue: Station(name: "上海", code: "SHH", pinyin: "shanghai", abbreviation: "sh")) }
}

struct Favorite: Codable, Hashable, DefaultsSerializable {
    let name: String
    let isPushEnabled: Bool
    
    init(_ name: String) {
        self.name = name
        self.isPushEnabled = false
    }
}

var Defaults = DefaultsAdapter<DefaultsKeys>(defaults: UserDefaults(suiteName: "group.me.njliner.chinaemu")!, keyStore: .init())

class UserDefaultsMigrater {
    static public func migrate() {
        let oldDefaults = DefaultsAdapter<DefaultsKeys>(defaults: UserDefaults.standard, keyStore: .init())
        if !oldDefaults[\.favoriteEMUs].isEmpty {
            Defaults[\.favoriteEMUs] = oldDefaults[\.favoriteEMUs]
            oldDefaults[\.favoriteEMUs] = []
        }
        if !oldDefaults[\.favoriteTrains].isEmpty {
            Defaults[\.favoriteTrains] = oldDefaults[\.favoriteTrains]
            oldDefaults[\.favoriteTrains] = []
        }
    }
}

