//
//  DepartureArrivalViewModel.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI

@MainActor
class DepartureArrivalViewModel: ObservableObject {
    let crProvider =  AbstractProvider<CRRequest>()
    let moeRailProvider = AbstractProvider<MoerailRequest>()
    private var loadTask: Task<Void, Never>?
    @Published var isLoading = true
    @Published var departureArrivals: [DepartureArrivalV2] = []
    @Published var emuTrainAssocs: [EMUTrainAssociation] = []
    
    public func getLeftTickets(from: String, to: String, date: Date) {
        loadTask?.cancel()
        loadTask = Task {
            await fetchLeftTickets(from: from, to: to, date: date)
        }
    }
    
    private func fetchLeftTickets(from: String, to: String, date: Date) async {
        isLoading = true
        do {
            let crResponse = try await crProvider.request(
                target: .leftTicketPrice(from: from, to: to, date: DateFormatter.standard.string(from: date)),
                as: CRResponse<[DepartureArrivalV2]>.self
            )
            try Task.checkCancellation()
            departureArrivals = crResponse.data
            let trainNumbers = departureArrivals.map { $0.v1.trainNo }
            let emus = try await moeRailProvider.request(target: .trains(keywords: trainNumbers), as: [EMUTrainAssociation].self)
            try Task.checkCancellation()
            emuTrainAssocs = emus
            isLoading = false
        } catch is CancellationError {
            isLoading = false
        } catch {
            isLoading = false
        }
    }
    
    deinit {
        loadTask?.cancel()
    }
}
