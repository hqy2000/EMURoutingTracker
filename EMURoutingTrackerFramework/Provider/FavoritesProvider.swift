//
//  FavoritesProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import Combine
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
    
    @discardableResult public func toggle(_ item: String) -> Bool {
        if contains(item) {
            _ = delete(item)
            return false
        } else {
            _ = add(item)
            return true
        }
    }
    
    private func mutateFavorites(_ transform: (inout [Favorite]) -> Void) {
        var entries = Defaults[key: defaultsKey]
        transform(&entries)
        Defaults[key: defaultsKey] = entries
        WidgetCenter.shared.reloadAllTimelines()
    }
}

@MainActor
enum FavoritesStore {
    static let shared = Store()
    
    final class Store: ObservableObject {
        @Published private(set) var trainFavorites: Set<String>
        @Published private(set) var emuFavorites: Set<String>
        
        fileprivate init() {
            trainFavorites = Self.names(from: .trains)
            emuFavorites = Self.names(from: .EMUs)
        }
        
        func contains(_ item: String, provider: FavoritesProvider) -> Bool {
            switch provider {
            case .trains:
                return trainFavorites.contains(item)
            case .EMUs:
                return emuFavorites.contains(item)
            }
        }
        
        func toggle(_ item: String, provider: FavoritesProvider) {
            provider.toggle(item)
            refresh(provider: provider)
        }
        
        func refresh(provider: FavoritesProvider? = nil) {
            if provider == nil || provider == .trains {
                trainFavorites = Self.names(from: .trains)
            }
            if provider == nil || provider == .EMUs {
                emuFavorites = Self.names(from: .EMUs)
            }
        }
        
        private static func names(from provider: FavoritesProvider) -> Set<String> {
            Set(provider.favorites.map(\.name))
        }
    }
}
