//
//  FavoritesProvider.swift
//  EMURoutingTracker
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
        Defaults[key: defaultsKey]
    }
    
    public func contains(_ item: String) -> Bool {
        favorites.contains { $0.name == item }
    }
    
    @discardableResult public func add(_ item: String) -> Bool {
        guard !contains(item) else { return false }
        mutateFavorites {
            $0.append(Favorite(item))
        }
        return true
    }
    
    @discardableResult public func delete(_ item: String) -> Bool {
        guard contains(item) else { return false }
        mutateFavorites {
            $0.removeAll { $0.name == item }
        }
        return true
    }
    
    private func mutateFavorites(_ transform: (inout [Favorite]) -> Void) {
        var entries = Defaults[key: defaultsKey]
        transform(&entries)
        Defaults[key: defaultsKey] = entries
        WidgetCenter.shared.reloadAllTimelines()
    }
}
