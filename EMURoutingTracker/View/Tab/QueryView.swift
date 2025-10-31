//
//  QueryView.swift
//  EMURoutingTracker
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
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("车组/车次查询")) {
                    TextField("G2/380/CRH2A2001", text: Binding(
                        get: { query },
                        set: { query = $0.filter { $0.isLetter || $0.isNumber }.uppercased() }
                    )).keyboardType(.asciiCapable).textInputAutocapitalization(.characters).onSubmit {
                        guard !query.isEmpty else { return }
                        path.append(Query.trainOrEmu(trainOrEmu: query))
                    }
                    Button {
                        guard !query.isEmpty else { return }
                        path.append(Query.trainOrEmu(trainOrEmu: query))
                    } label: {
                        Text("查询").frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                Section(header: Text("发着查询")) {
                    NavigationLink(
                        destination: StationPicker(provider.stations, completion: { station in
                            Defaults[\.lastDeparture] = station
                            departure = station
                        }),
                        label: {
                            HStack {
                                Text("出发地")
                                Spacer()
                                Text(departure.name)
                            }
                        })
                    NavigationLink(
                        destination: StationPicker(provider.stations, completion: { station in
                            Defaults[\.lastArrival] = station
                            arrival = station
                        }),
                        label: {
                            HStack{
                                Text("目的地")
                                Spacer()
                                Text(arrival.name)
                            }
                        })
                    DatePicker("出发日期", selection: $date, displayedComponents: .date)
                    Button {
                        path.append(Query.remainingTickets(depature: departure, arrival: arrival, date: date))
                    } label: {
                        Text("查询").frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                }
            }
            .listStyle(InsetGroupedListStyle())
            .queryNavigation(path: $path)
        }
    }
}
