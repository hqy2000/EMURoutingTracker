//
//  QueryView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI
import SwiftyUserDefaults

struct QueryView: View {
    @State var query = ""
    @State var departure: Station = Defaults[\.lastDeparture]
    @State var arrival: Station = Defaults[\.lastArrival]
    @State var date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @ObservedObject var provider = StationProvider.shared
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("车组/车次查询")) {
                    TextField("G2/380/CRH2A2001", text: $query).keyboardType(.asciiCapable)
                    NavigationLink(
                        destination: MoerailView(query),
                        label: {
                            Text("查询")
                        })
                }
                Section(header: Text("发着查询")) {
                    NavigationLink(
                        destination: SearchListView(provider.stations, completion: { station in
                            Defaults[\.lastDeparture] = station
                            self.departure = station
                        }),
                        label: {
                            HStack {
                                Text("出发地")
                                Spacer()
                                Text(self.departure.name ?? "")
                            }
                        })
                    NavigationLink(
                        destination: SearchListView(provider.stations, completion: { station in
                            Defaults[\.lastArrival] = station
                            self.arrival = station
                        }),
                        label: {
                            HStack{
                                Text("目的地")
                                Spacer()
                                Text(self.arrival.name ?? "")
                            }
                            
                        })
                    DatePicker("出发日期", selection: $date, displayedComponents: .date)
                    NavigationLink("查询", destination: LeftTicketsView(departure: self.departure.code, arrival: self.arrival.code, date: self.date))
                    
                }
            }.listStyle(InsetGroupedListStyle())
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
