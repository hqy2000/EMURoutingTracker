//
//  SingleEMUView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct SingleEMUView: View {
    @EnvironmentObject var moerailData: MoerailData
    var body: some View {
        List {
            ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                        HStack {
                            Text(emu.train)
                                .font(Font.body.monospacedDigit())
                            Spacer()
                            if emu.timetable.first?.station != nil {
                                Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")")
                            } else {
                                ProgressView()
                            }
                            
                        }.onTapGesture {
                            self.moerailData.getTrackingRecord(keyword: emu.singleTrain)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image("CRH2A")
                    Text(moerailData.query).font(.headline)
                }
            }
        }
        .navigationBarItems(trailing: Button("完成") {
            self.moerailData.getTrackingRecord(keyword: "")
        })
    }
}

struct SingleEMUView_Previews: PreviewProvider {
    static var previews: some View {
        SingleEMUView()
    }
}
