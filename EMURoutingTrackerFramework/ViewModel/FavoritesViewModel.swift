//
//  FavouritesProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults
import RxSwift

class FavoritesViewModel: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>()
    @Published var favoriteEMUs: [EMUTrainAssociation] = []
    @Published var favoriteTrains: [EMUTrainAssociation] = []
    private var lastRefresh: Date? = nil
    private let disposeBag = DisposeBag()
    private let batchSize = 20
    
    init() {
        refresh()
    }
    
    public func refresh(completion: (() -> Void)? = nil) {
        // Avoid 503 issues by skipping frequent requests
        guard lastRefresh == nil || Date().timeIntervalSince(lastRefresh!) >= 15.0 else {
            print("Too frequent, skip this request.")
            completion?()
            return
        }
        lastRefresh = Date()
        
        favoriteTrains = FavoritesProvider.trains.favorites.map { favorite in
            EMUTrainAssociation(emu: "", train: favorite.name, date: "")
        }
        favoriteEMUs = FavoritesProvider.EMUs.favorites.map { favorite in
            EMUTrainAssociation(emu: favorite.name, train: "", date: "")
        }
        
        let trainsSingle = queryInBatches(
            items: FavoritesProvider.trains.favorites.map { $0.name },
            associationTypeGenerator: { .trains(keywords: $0) }
        ).do(onSuccess: { [weak self] result in
            self?.favoriteTrains = result
            result.enumerated().forEach { index, emu in
                TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { trainInfo in
                    self?.favoriteTrains[index].trainInfo = trainInfo
                }
            }
        })
        
        let emusSingle = queryInBatches(
            items: FavoritesProvider.EMUs.favorites.map { $0.name },
            associationTypeGenerator: { .emus(keywords: $0) }
        ).do(onSuccess: { [weak self] result in
            self?.favoriteEMUs = result
            result.enumerated().forEach { index, emu in
                TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { trainInfo in
                    self?.favoriteEMUs[index].trainInfo = trainInfo
                }
            }
        })
        
        Single.zip(trainsSingle, emusSingle)
            .observe(on: MainScheduler.instance)
            .subscribe({ _ in
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
    private func queryInBatches(
        items: [String],
        associationTypeGenerator: ([String]) -> MoerailRequest
    ) -> Single<[EMUTrainAssociation]> {
        guard !items.isEmpty else {
            return Single.just([]) // Return an empty observable if the list is empty
        }
        
        let batches = items.chunked(into: batchSize)
        let observables = batches.map { [weak self] batch -> Observable<[EMUTrainAssociation]> in
            guard let self else {
                return Observable.just([])
            }
            return self.moerailProvider.request(target: associationTypeGenerator(batch), type: [EMUTrainAssociation].self).asObservable()
        }
        
        return Observable.concat(observables)
            .reduce([]) { $0 + $1 }
            .asSingle()
    }
    
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
