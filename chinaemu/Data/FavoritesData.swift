//
//  FavouritesProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults

class FavoritesData: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>();
    //@State var favoriteEMUs: [EMU] = []
    @Published var favoriteTrains: [EMU] = []
    
    init() {
        self.refresh()
    }
    
    public func refresh() {
        if self.favoriteTrains.isEmpty {
            self.favoriteTrains = FavoritesProvider.shared.favoriteTrains.map({ (favorite) in
                return EMU(emu: "", train: favorite.name, date: "")
            })
        }
        
        moerailProvider.request(target: .trains(keywords: FavoritesProvider.shared.favoriteTrains.map({ favorite in
            return favorite.name
        })), type: [EMU].self) { (result) in
            self.favoriteTrains = result
            for (index, emu) in result.enumerated() {
                TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                    self.favoriteTrains[index].timetable = timetable
                }
            }
        } failure: { (error) in
            print(error)
        }
    }
}
