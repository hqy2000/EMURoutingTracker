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
    
    init() {
    }
    
    public func refresh() {
        Task {
            await refreshIfNeeded()
        }
    }
    
    public func refreshIfNeeded(force: Bool = false) async {
        guard force || shouldRefresh else {
            print("Too frequent, skip this request.")
            return
        }
        lastRefresh = Date()
        
        do {
            try await fetchFavorites(
                from: .trains,
                keyPath: \.favoriteTrains,
                placeholderBuilder: { favorite in
                    EMUTrainAssociation(emu: "", train: favorite.name, date: "")
                },
                requestBuilder: { .trains(keywords: $0) }
            )
        } catch is CancellationError {
            return
        } catch {
            // Preserve previous behaviour by silently ignoring failures.
        }
        
        do {
            try await fetchFavorites(
                from: .EMUs,
                keyPath: \.favoriteEMUs,
                placeholderBuilder: { favorite in
                    EMUTrainAssociation(emu: favorite.name, train: "", date: "")
                },
                requestBuilder: { .emus(keywords: $0) }
            )
        } catch is CancellationError {
            return
        } catch {
            // Preserve previous behaviour by silently ignoring failures.
        }
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
    
    private func fetchFavorites(
        from provider: FavoritesProvider,
        keyPath: ReferenceWritableKeyPath<FavoritesViewModel, [EMUTrainAssociation]>,
        placeholderBuilder: (Favorite) -> EMUTrainAssociation,
        requestBuilder: ([String]) -> MoerailRequest
    ) async throws {
        let storedFavorites = provider.favorites
        
        if self[keyPath: keyPath].isEmpty && !storedFavorites.isEmpty {
            self[keyPath: keyPath] = storedFavorites.map(placeholderBuilder)
        }
        
        guard !storedFavorites.isEmpty else {
            self[keyPath: keyPath] = []
            return
        }
        
        let result = try await queryInBatches(
            items: storedFavorites.map(\.name),
            associationTypeGenerator: requestBuilder
        )
        try Task.checkCancellation()
        self[keyPath: keyPath] = result
        await populateTrainInfo(for: keyPath)
    }
    
    private var shouldRefresh: Bool {
        guard let lastRefresh else { return true }
        return Date().timeIntervalSince(lastRefresh) >= 15.0
    }
    
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { Array(self[$0..<Swift.min($0 + size, count)]) }
    }
}
