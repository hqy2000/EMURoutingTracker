//
//  LeftTicketsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct DepartureArrivalList: View {
    @ObservedObject var crData = CRData()
    
    let departure: String
    let arrival: String
    let date: Date
    
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(crData.leftTickets, id: \.id) { (leftTicket) in
                RemaingTicketRowView(path: $path, leftTicket: leftTicket.leftTicket, emu: crData.emus.first(where: {$0.train == leftTicket.leftTicket.trainNo}))
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
        DepartureArrivalList(departure: "BJP", arrival: "SHH", date: Date(), path: Binding.constant(NavigationPath()))
    }
}
