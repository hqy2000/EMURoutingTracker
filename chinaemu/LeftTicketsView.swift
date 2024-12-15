//
//  LeftTicketsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct LeftTicketsView: View {
    @ObservedObject var crData = CRData()
    @Binding var path: NavigationPath
    
    let departure: String
    let arrival: String
    let date: Date
    
    var body: some View {
        List {
            ForEach(crData.leftTickets, id: \.id) { (leftTicket) in
                LeftTicketView(path: $path, leftTicket: leftTicket.leftTicket, emu: crData.emus.first(where: {$0.train == leftTicket.leftTicket.trainNo}))
            }
        }.onAppear(perform: {
            if self.crData.leftTickets.isEmpty {
                self.crData.getLeftTickets(from: self.departure, to: self.arrival, date: date)
            }
        })
    }
}

struct LeftTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTicketsView(path: Binding.constant(NavigationPath()), departure: "BJP", arrival: "SHH", date: Date())
    }
}
