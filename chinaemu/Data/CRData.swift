//
//  CRData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache

class CRData: ObservableObject {
    let crProvider =  AbstractProvider<CRRequest>();
    let moeRailProvider = AbstractProvider<MoerailRequest>();
    @Published var leftTickets: [LeftTicket] = []
    @Published var emus: [EMU] = []
    public func getLeftTickets(from: String, to: String, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        crProvider.request(target: .leftTicket(from: from, to: to, date: dateFormatter.string(from: date)), type: CRResponse<CRDatasWrapper<[LeftTicket]>>.self) { (result) in
            print(result)
            self.leftTickets = result.data.data
            self.moeRailProvider.request(target: .trains(keywords: result.data.data.map({ $0.trainNo })), type: [EMU].self, success: { (emus) in
                self.emus = emus
            })
        }
    }
}
