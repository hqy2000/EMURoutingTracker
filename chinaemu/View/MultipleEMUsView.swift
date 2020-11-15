//
//  MultipleEMUsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct MultipleEMUsView: View {
    @EnvironmentObject var moerailData: MoerailData
    var body: some View {
        List {
            ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                        HStack {
                            Image("CRH2A")
                            Text(emu.emu)
                                .font(Font.body.monospacedDigit())
                                .onTapGesture {
                                    self.moerailData.getTrackingRecord(keyword: emu.emu)
                                }
                            Spacer()
                            VStack(spacing: 4) {
                                HStack {
                                    Spacer()
                                    Text(emu.train)
                                        .font(Font.callout)
                                }
                                HStack {
                                    Spacer()
                                    Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")").font(Font.caption2)
                                }
                            }.onTapGesture {
                                self.moerailData.getTrackingRecord(keyword: emu.singleTrain)
                            }

                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(moerailData.query).font(.headline)
                }
            }
        }
        .navigationBarItems(trailing: Button("完成") {
            self.moerailData.getTrackingRecord(keyword: "")
        })
    }
}

struct MultipleEMUsView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleEMUsView()
    }
}
