//
//  DepartureArrivalList.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct DepartureArrivalList: View {
    @ObservedObject var vm = DepartureArrivalViewModel()
    
    let departure: String
    let arrival: String
    let date: Date
    
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(vm.departureArrivals, id: \.id) { (departureArrival) in
                DepartureArrivalRow(path: $path, departureArrival: departureArrival.v1, emu: vm.emuTrainAssocs.first(where: {$0.train == departureArrival.v1.trainNo}))
            }
        }.onAppear(perform: {
            if self.vm.departureArrivals.isEmpty {
                self.vm.getLeftTickets(from: self.departure, to: self.arrival, date: date)
            }
        }).navigationTitle("发着查询")
    }
}

struct LeftTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        DepartureArrivalList(departure: "BJP", arrival: "SHH", date: Date(), path: Binding.constant(NavigationPath()))
    }
}
