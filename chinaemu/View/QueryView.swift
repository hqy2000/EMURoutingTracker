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
    @State var departure = ""
    @State var arrival = ""
    @State var date = Date()
    @ObservedObject var provider = StationProvider.shared
    @ObservedObject var crData = CRData()
    var body: some View {
        List {
            Section(header: Text("车组号/车次查询")) {
                HStack {
                    TextField("CRH2A2001", text: $query)
//                    } onCommit: {
//                        self.moerailData.getTrackingRecord(keyword: query)
//                    }.textFieldStyle(RoundedBorderTextFieldStyle())
                    NavigationLink(
                        destination: MoerailView(query),
                        label: {
                            Text("搜索")
                        }).frame(width: 70)
                }
            }
            Section(header: Text("发着查询")) {

                Picker("出发地", selection: $departure) {
                    ForEach(provider.stations, id: \.code) { station in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(station.name)
                                Text(station.pinyin).font(.caption2)
                            }
                            Spacer()
                            Text(station.code).font(.system(.body, design: .monospaced))
                        }
                    }
                }
                Picker("目的地", selection: $arrival) {
                    ForEach(provider.stations, id: \.code) { station in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(station.name)
                                Text(station.pinyin).font(.caption2)
                            }
                            Spacer()
                            Text(station.code).font(.system(.body, design: .monospaced))
                        }
                    }
                }
                DatePicker("出发日期", selection: $date, displayedComponents: .date)
                Button("查询") {
                    print(departure)
                    crData.getLeftTickets(from: departure, to: arrival, date: date)
                }
                
            }
        }.listStyle(InsetGroupedListStyle())
        
    }
}
