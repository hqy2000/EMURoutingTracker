//
//  FavoritesProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftyUserDefaults

internal class FavoritesProvider {
    public static let shared = FavoritesProvider()
    var favoriteTrains: [Favorite] {
        Defaults[\.favoriteTrains]
    }
    var favoriteEMUs: [Favorite] {
        Defaults[\.favoriteEMUs]
    }
    
    private init() {}
    
    public func contains(train: String) -> Bool {
        if Defaults.favoriteTrains.contains(where: {$0.name == train}) {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func add(train: String) -> Bool {
        if !self.contains(train: train) {
            Defaults.favoriteTrains.append(Favorite(train))
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func delete(train: String) -> Bool {
        if let index = Defaults.favoriteTrains.firstIndex(where: {$0.name == train}) {
            Defaults.favoriteTrains.remove(at: index)
            return true
        } else {
            return false
        }
    }

    public func contains(emu: String) -> Bool {
        if Defaults.favoriteEMUs.contains(where: {$0.name == emu}) {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func add(emu: String) -> Bool {
        if !self.contains(emu: emu) {
            Defaults.favoriteEMUs.append(Favorite(emu))
            return true
        } else {
            return false
        }
    }
    
    @discardableResult public func delete(emu: String) -> Bool {
        if let index = Defaults.favoriteEMUs.firstIndex(where: {$0.name == emu}) {
            Defaults.favoriteEMUs.remove(at: index)
            return true
        } else {
            return false
        }
    }


}
