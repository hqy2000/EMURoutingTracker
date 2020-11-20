//
//  CRData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache

class CRData: AbstractProvider<CRRequest>, ObservableObject {
    public func getLeftTickets(from: String, to: String, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.request(target: .leftTicket(from: from, to: to, date: dateFormatter.string(from: date)), type: CRResponse<CRDatasWrapper<[LeftTicket]>>.self) { (result) in
            print(result)
        }
    }
}
