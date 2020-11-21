//
//  LeftTicketsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct LeftTicketsView: View {
    @ObservedObject var crData = CRData()
    var body: some View {
        List {
            ForEach(crData.leftTickets, id: \.id) { (leftTicket) in
                LeftTicketView(leftTicket, crData.emus.first(where: {$0.train == leftTicket.trainNo}))
            }
        }.onAppear(perform: {
            self.crData.getLeftTickets(from: "NJH", to: "SZH", date: Date().addingTimeInterval(60*60*6))
        }).navigationTitle("发着查询")
    }
}

struct LeftTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTicketsView()
    }
}
