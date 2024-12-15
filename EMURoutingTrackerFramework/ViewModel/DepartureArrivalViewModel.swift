//
//  DepartureArrivalViewModel.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache

class DepartureArrivalViewModel: ObservableObject {
    let crProvider =  AbstractProvider<CRRequest>();
    let moeRailProvider = AbstractProvider<MoerailRequest>();
    @Published var departureArrivals: [DepartureArrivalV2] = []
    @Published var emuTrainAssocs: [EMUTrainAssociation] = []
    
    public func getLeftTickets(from: String, to: String, date: Date) {
        crProvider.request(target: .leftTicketPrice(from: from, to: to, date: DateFormatter.standard.string(from: date)), type: CRResponse<[DepartureArrivalV2]>.self) { (result) in
            self.departureArrivals = result.data
            self.moeRailProvider.request(target: .trains(keywords: result.data.map({ $0.v1.trainNo })), type: [EMUTrainAssociation].self, success: { (emus) in
                self.emuTrainAssocs = emus
            })
        }
    }
}
