//
//  QueryView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI

struct QueryView: View {
    @State var query = ""
    @State var departure: Station = Station(name: "北京", code: "BJP", pinyin: "beijing", abbreviation: "bj")
    @State var arrival: Station = Station(name: "上海", code: "SHH", pinyin: "shanghai", abbreviation: "sh")
    @State var date = Date()
    @ObservedObject var provider = StationProvider.shared
    var body: some View {
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
                        self.arrival = station
                    }),
                    label: {
                        HStack{
                            Text("目的地")
                            Spacer()
                            Text(self.arrival.name ?? "")
                        }
                       
                    })
//
//                Picker("出发地", selection: $departure) {
//                    ForEach(provider.stations, id: \.code) { station in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(station.name)
//                                Text(station.pinyin).font(.caption2)
//                            }
//                            Spacer()
//                            Text(station.code).font(.system(.body, design: .monospaced))
//                        }
//                    }.navigationTitle("出发地选择")
//                }
//                Picker("目的地", selection: $arrival) {
//                    ForEach(provider.stations, id: \.code) { station in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(station.name)
//                                Text(station.pinyin).font(.caption2)
//                            }
//                            Spacer()
//                            Text(station.code).font(.system(.body, design: .monospaced))
//                        }
//                    }.navigationTitle("目的地选择")
//                }
                DatePicker("出发日期", selection: $date, displayedComponents: .date)
                NavigationLink("查询", destination: LeftTicketsView(departure: self.departure.code, arrival: self.arrival.code, date: self.date))
                
            }
        }.listStyle(InsetGroupedListStyle())
        
    }
}
