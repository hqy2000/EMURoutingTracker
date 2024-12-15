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
    @Published var favoriteEMUs: [EMUTrainAssociation] = []
    @Published var favoriteTrains: [EMUTrainAssociation] = []
    private var lastRefresh: Date? = nil
    
    init() {
        self.refresh()
    }
    
    private func completionCheck(count: inout Int, completion: (() -> Void)?) {
        DispatchQueue.global().sync {
            count -= 1
            if count == 0 {
                completion?()
            }
        }
    }
    
    public func refresh(completion: (() -> Void)? = nil) {
        var taskCount = 2
        if self.favoriteTrains.isEmpty {
            self.favoriteTrains = FavoritesProvider.trains.favorites.map({ (favorite) in
                return EMUTrainAssociation(emu: "", train: favorite.name, date: "")
            })
        }
        
        if self.favoriteEMUs.isEmpty {
            self.favoriteEMUs = FavoritesProvider.EMUs.favorites.map({ (favorite) in
                return EMUTrainAssociation(emu: favorite.name, train: "", date: "")
            })
        }
        
        // Avoid 503 issues.
        if lastRefresh != nil && Date().timeIntervalSince(lastRefresh!) < 15.0 && completion == nil {
            print("Too frequent, skip this request.")
            completion?()
            return
        }
        lastRefresh = Date()
        
        if !FavoritesProvider.trains.favorites.isEmpty {
            moerailProvider.request(target: .trains(keywords: FavoritesProvider.trains.favorites.map({ favorite in
                return favorite.name
            })), type: [EMUTrainAssociation].self) { (result) in
                self.favoriteTrains = result
                if completion == nil {
                    for (index, emu) in result.enumerated() {
                        TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                            self.favoriteTrains[index].trainInfo = trainInfo
                        }
                    }
                }
                self.completionCheck(count: &taskCount, completion: completion)
            } failure: { (error) in
                debugPrint(error)
                self.completionCheck(count: &taskCount, completion: completion)
            }
        } else {
            self.completionCheck(count: &taskCount, completion: completion)
        }
       
        
        if !FavoritesProvider.EMUs.favorites.isEmpty {
            moerailProvider.request(target: .emus(keywords: FavoritesProvider.EMUs.favorites.map({ favorite in
                return favorite.name
            })), type: [EMUTrainAssociation].self) { (result) in
                self.favoriteEMUs = result
                if completion == nil {
                    for (index, emu) in result.enumerated() {
                        TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { (trainInfo) in
                            self.favoriteEMUs[index].trainInfo = trainInfo
                        }
                    }
                }
                self.completionCheck(count: &taskCount, completion: completion)
            } failure: { (error) in
                debugPrint(error)
                self.completionCheck(count: &taskCount, completion: completion)
            }
        } else {
            self.completionCheck(count: &taskCount, completion: completion)
        }
    }
}
