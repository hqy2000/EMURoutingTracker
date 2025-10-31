//
//  FavouritesProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults

@MainActor
class FavoritesViewModel: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>()
    @Published var favoriteEMUs: [EMUTrainAssociation] = []
    @Published var favoriteTrains: [EMUTrainAssociation] = []
    private var lastRefresh: Date? = nil
    private let batchSize = 20
    private var refreshTask: Task<Void, Never>?
    
    init() {
    }
    
    public func refreshAsync() async {
        await withCheckedContinuation { continuation in
            refresh {
                continuation.resume()
            }
        }
    }
    
    public func refresh(completion: (() -> Void)? = nil) {
        // Avoid 503 issues by skipping frequent requests
        guard lastRefresh == nil || Date().timeIntervalSince(lastRefresh!) >= 15.0 else {
            print("Too frequent, skip this request.")
            completion?()
            return
        }
        lastRefresh = Date()
        
        refreshTask?.cancel()
        refreshTask = Task {
            await performRefresh(completion: completion)
        }
    }
    
    private func performRefresh(completion: (() -> Void)?) async {
        if favoriteTrains.isEmpty {
            favoriteTrains = FavoritesProvider.trains.favorites.map { favorite in
                EMUTrainAssociation(emu: "", train: favorite.name, date: "")
            }
        }
        
        if favoriteEMUs.isEmpty {
            favoriteEMUs = FavoritesProvider.EMUs.favorites.map { favorite in
                EMUTrainAssociation(emu: favorite.name, train: "", date: "")
            }
        }
        
        do {
            let trainsResult = try await queryInBatches(
                items: FavoritesProvider.trains.favorites.map { $0.name },
                associationTypeGenerator: { .trains(keywords: $0) }
            )
            try Task.checkCancellation()
            favoriteTrains = trainsResult
            await populateTrainInfo(for: \.favoriteTrains)
        } catch is CancellationError {
            completion?()
            return
        } catch {
            // Preserve previous behaviour by silently ignoring failures.
        }
        
        do {
            let emusResult = try await queryInBatches(
                items: FavoritesProvider.EMUs.favorites.map { $0.name },
                associationTypeGenerator: { .emus(keywords: $0) }
            )
            try Task.checkCancellation()
            favoriteEMUs = emusResult
            await populateTrainInfo(for: \.favoriteEMUs)
        } catch is CancellationError {
            completion?()
            return
        } catch {
            // Preserve previous behaviour by silently ignoring failures.
        }
        
        completion?()
    }
    
    private func populateTrainInfo(for keyPath: ReferenceWritableKeyPath<FavoritesViewModel, [EMUTrainAssociation]>) async {
        for index in self[keyPath: keyPath].indices {
            if Task.isCancelled { return }
            let trainCode = self[keyPath: keyPath][index].singleTrain
            guard !trainCode.isEmpty else { continue }
            if let trainInfo = try? await TrainInfoProvider.shared.get(forTrain: trainCode) {
                if Task.isCancelled { return }
                if self[keyPath: keyPath].indices.contains(index) {
                    self[keyPath: keyPath][index].trainInfo = trainInfo
                }
            }
        }
    }
    
    private func queryInBatches(
        items: [String],
        associationTypeGenerator: ([String]) -> MoerailRequest
    ) async throws -> [EMUTrainAssociation] {
        guard !items.isEmpty else {
            return []
        }
        
        var results: [EMUTrainAssociation] = []
        
        let batches = items.chunked(into: batchSize)
        for batch in batches {
            try Task.checkCancellation()
            let result = try await moerailProvider.request(target: associationTypeGenerator(batch), as: [EMUTrainAssociation].self)
            results.append(contentsOf: result)
        }
        return results
    }
    
    deinit {
        refreshTask?.cancel()
    }
    
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
