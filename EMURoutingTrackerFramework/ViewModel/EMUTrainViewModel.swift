//
//  MoerailData.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import SwiftUI

@MainActor
class EMUTrainViewModel: ObservableObject {
    let moerailProvider = AbstractProvider<MoerailRequest>()
    private var fetchTask: Task<Void, Never>?
    
    @Published var emuTrainAssocList = [EMUTrainAssociation]()
    @Published var mode: Mode = .loading
    @Published var query = ""
    @Published var errorMessage = ""
    
    enum Mode {
        case loading
        case emptyTrain
        case emptyEmu
        case error
        case singleTrain
        case singleEmu
        case multipleEmus
    }
    
    var groupedByDay: [String: [EMUTrainAssociation]] {
        return Dictionary(grouping: emuTrainAssocList, by: { $0.date })
    }
    
    public func postTrackingURL(url: String, completion: (() -> Void)? = nil) {
        guard !url.isEmpty else { return }
        let currentQuery = query
        let provider = moerailProvider
        Task {
            do {
                _ = try await provider.request(target: .qr(emu: currentQuery, url: url), as: [EMUTrainAssociation].self)
                completion?()
            } catch {
                // Ignore errors for QR submissions to retain previous behaviour.
            }
        }
    }
    
    public func getTrackingRecord(keyword: String) {
        fetchTask?.cancel()
        fetchTask = Task {
            await handleGetTrackingRecord(keyword: keyword)
        }
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    private func handleGetTrackingRecord(keyword: String) async {
        await TrainInfoProvider.shared.cancelAll()
        query = keyword
        mode = .loading
        let trimmed = keyword.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            emuTrainAssocList = []
            mode = .emptyTrain
            return
        }
        
        do {
            if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
                let results = try await moerailProvider.request(target: .train(keyword: keyword), as: [EMUTrainAssociation].self)
                try Task.checkCancellation()
                emuTrainAssocList = results
                mode = emuTrainAssocList.isEmpty ? .emptyTrain : .singleTrain
                await populateTrainInfo()
            } else {
                emuTrainAssocList = []
                let results = try await moerailProvider.request(target: .emu(keyword: keyword), as: [EMUTrainAssociation].self)
                try Task.checkCancellation()
                emuTrainAssocList = results
                updateModeForEmuResults()
                await populateTrainInfo()
            }
        } catch is CancellationError {
            // Ignore cancellations.
        } catch {
            await handleError(error)
        }
    }
    
    private func updateModeForEmuResults() {
        if emuTrainAssocList.isEmpty {
            mode = .emptyEmu
        } else if mode == .loading {
            mode = .singleEmu
        }
        for index in emuTrainAssocList.indices where index > 0 {
            if emuTrainAssocList[index].emu != emuTrainAssocList[index - 1].emu {
                mode = .multipleEmus
                return
            }
        }
    }
    
    private func populateTrainInfo() async {
        for (index, emu) in emuTrainAssocList.enumerated() {
            if Task.isCancelled { return }
            do {
                let trainInfo = try await TrainInfoProvider.shared.get(forTrain: emu.singleTrain)
                if Task.isCancelled { return }
                if emuTrainAssocList.indices.contains(index) {
                    emuTrainAssocList[index].trainInfo = trainInfo
                }
            } catch {
                // Ignore failures retrieving individual train info to match previous silent failure behaviour.
            }
        }
    }
    
    public func handleError(_ error: Error) async {
        mode = .error
        if let error = error as? NetworkError {
            if error.code == 503 {
                errorMessage = "服务暂时不可用，请稍后再试"
            } else if error.code == 404 {
                errorMessage = "\"\(query)\"不是一个正确的车次或车组。"
            } else {
                errorMessage = error.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }
    
}
