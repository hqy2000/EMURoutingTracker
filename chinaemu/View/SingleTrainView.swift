//
//  SingleTrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct SingleTrainView: View {
    @EnvironmentObject var moerailData: MoerailData
    var body: some View {
        List {
            ForEach(moerailData.emuList, id: \.id) { emu in
                HStack {
                    Image("CRH2A")
                    Text(emu.emu)
                        .font(Font.body.monospacedDigit())
                    Spacer()
                    Text(emu.date)
                        .font(Font.caption.monospacedDigit())
                }.onTapGesture {
                    self.moerailData.getTrackingRecord(keyword: emu.emu)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    if self.moerailData.emuList.first?.timetable.first?.station != nil {
                        Text(self.moerailData.query + " \(self.moerailData.emuList.first?.timetable.first?.station ?? "") ⇀ \(self.moerailData.emuList.first?.timetable.last?.station ?? "")").font(.headline)
                    } else {
                        VStack {
                            Text(self.moerailData.query)
                            ProgressView()
                        }
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button("完成") {
            self.moerailData.getTrackingRecord(keyword: "")
        })
    }
}

struct SingleTrainView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTrainView()
    }
}
