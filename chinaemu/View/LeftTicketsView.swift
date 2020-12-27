//
//  LeftTicketsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct LeftTicketsView: View {
    @ObservedObject var crData = CRData()
    let departure: String
    let arrival: String
    let date: Date
    init(departure: String, arrival: String, date: Date) {
        self.departure = departure
        self.arrival = arrival
        self.date = date
    }
    
    var body: some View {
        List {
            ForEach(crData.leftTickets, id: \.id) { (leftTicket) in
                LeftTicketView(leftTicket.leftTicket, crData.emus.first(where: {$0.train == leftTicket.leftTicket.trainNo}))
            }
        }.onAppear(perform: {
            if self.crData.leftTickets.isEmpty {
                self.crData.getLeftTickets(from: self.departure, to: self.arrival, date: date)
            }
        }).navigationTitle("发着查询")
    }
}

struct LeftTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTicketsView(departure: "BJP", arrival: "SHH", date: Date())
    }
}
