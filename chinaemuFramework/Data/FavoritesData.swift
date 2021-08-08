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
    @Published var favoriteEMUs: [EMU] = []
    @Published var favoriteTrains: [EMU] = []
    private var lastRefresh: Date? = nil
    
    init() {
        self.refresh()
    }
    
    private func completionCheck(count: inout Int, completion: (() -> Void)?) {
        DispatchQueue.global().sync {
            count -= 1
            print(count)
            if count == 0 {
                completion?()
            }
        }
    }
    
    public func refresh(completion: (() -> Void)? = nil) {
        var taskCount = 2
        if self.favoriteTrains.isEmpty {
            self.favoriteTrains = FavoritesProvider.shared.favoriteTrains.map({ (favorite) in
                return EMU(emu: "", train: favorite.name, date: "")
            })
        }
        
        if self.favoriteEMUs.isEmpty {
            self.favoriteEMUs = FavoritesProvider.shared.favoriteEMUs.map({ (favorite) in
                return EMU(emu: favorite.name, train: "", date: "")
            })
        }
        
        // Avoid 503 issues.
        if lastRefresh != nil && Date().timeIntervalSince(lastRefresh!) < 15.0 {
            print("Too frequent, skip this request.")
            completion?()
            return
        }
        lastRefresh = Date()
        
        if !FavoritesProvider.shared.favoriteTrains.isEmpty {
            moerailProvider.request(target: .trains(keywords: FavoritesProvider.shared.favoriteTrains.map({ favorite in
                return favorite.name
            })), type: [EMU].self) { (result) in
                self.favoriteTrains = result
                if completion == nil {
                    for (index, emu) in result.enumerated() {
                        TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                            self.favoriteTrains[index].timetable = timetable
                        }
                    }
                }
                self.completionCheck(count: &taskCount, completion: completion)
            } failure: { (error) in
                print(error)
                self.completionCheck(count: &taskCount, completion: completion)
            }
        } else {
            self.completionCheck(count: &taskCount, completion: completion)
        }
       
        
        if !FavoritesProvider.shared.favoriteEMUs.isEmpty {
            moerailProvider.request(target: .emus(keywords: FavoritesProvider.shared.favoriteEMUs.map({ favorite in
                return favorite.name
            })), type: [EMU].self) { (result) in
                self.favoriteEMUs = result
                if completion == nil {
                    for (index, emu) in result.enumerated() {
                        TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                            self.favoriteEMUs[index].timetable = timetable
                        }
                    }
                }
                self.completionCheck(count: &taskCount, completion: completion)
            } failure: { (error) in
                print(error)
                self.completionCheck(count: &taskCount, completion: completion)
            }
        } else {
            self.completionCheck(count: &taskCount, completion: completion)
        }
    }
}
