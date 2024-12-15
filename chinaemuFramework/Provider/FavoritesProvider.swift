//
//  FavoritesProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftyUserDefaults
import WidgetKit

internal enum FavoritesProvider {
    case trains
    case EMUs
    
    private var defaultsKey: DefaultsKey<[Favorite]>  {
        switch self {
        case .trains:
            return DefaultsKeys().favoriteTrains
        case .EMUs:
            return DefaultsKeys().favoriteEMUs
        }
    }
    
    public var favorites: [Favorite] {
        return Defaults[key: defaultsKey]
    }
    
    public func contains(_ item: String) -> Bool {
        if Defaults[key: defaultsKey].contains(where: {$0.name == item}) {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func add(_ item: String) -> Bool {
        if !self.contains(item) {
            Defaults[key: defaultsKey].append(Favorite(item))
            WidgetCenter.shared.reloadAllTimelines()
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func delete(_ item: String) -> Bool {
        if let index = Defaults[key: defaultsKey].firstIndex(where: {$0.name == item}) {
            Defaults[key: defaultsKey].remove(at: index)
            WidgetCenter.shared.reloadAllTimelines()
            return true
        } else {
            return false
        }
    }
}
