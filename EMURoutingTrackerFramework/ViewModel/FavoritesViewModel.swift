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
        self.refresh()
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
        
        let trainsObservable = queryInBatches(
            items: FavoritesProvider.trains.favorites.map { $0.name },
            associationTypeGenerator: { .trains(keywords: $0) }
        ).do(onNext: { [weak self] result in
            self?.favoriteTrains = result
            result.enumerated().forEach { index, emu in
                TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { trainInfo in
                    self?.favoriteTrains[index].trainInfo = trainInfo
                }
            }
        })
        
        let emusObservable = queryInBatches(
            items: FavoritesProvider.EMUs.favorites.map { $0.name },
            associationTypeGenerator: { .emus(keywords: $0) }
        ).do(onNext: { [weak self] result in
            self?.favoriteEMUs = result
            result.enumerated().forEach { index, emu in
                TrainInfoProvider.shared.get(forTrain: emu.singleTrain) { trainInfo in
                    self?.favoriteEMUs[index].trainInfo = trainInfo
                }
            }
        })
        
        Observable.zip(trainsObservable, emusObservable)
            .observe(on: MainScheduler.instance)
            .subscribe(onError: { error in
                debugPrint(error)
                completion?()
            }, onCompleted: {
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
    private func queryInBatches(
        items: [String],
        associationTypeGenerator: ([String]) -> MoerailRequest
    ) -> Observable<[EMUTrainAssociation]> {
        guard !items.isEmpty else {
            return Observable.just([]) // Return an empty observable if the list is empty
        }
        
        let batches = items.chunked(into: batchSize)
        let observables = batches.map { batch in
            fetchTrainAssociations(associationType: associationTypeGenerator(batch))
        }
        
        return Observable.concat(observables)
            .reduce([]) { $0 + $1 } // Combine all results into a single array
    }
    
    private func fetchTrainAssociations(
        associationType: MoerailRequest
    ) -> Observable<[EMUTrainAssociation]> {
        return Observable.create { observer in
            self.moerailProvider.request(
                target: associationType,
                type: [EMUTrainAssociation].self
            ) { result in
                observer.onNext(result)
                observer.onCompleted()
            } failure: { error in
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
