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
                    Image(emu.image)
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
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    if self.moerailData.emuList.first?.timetable.first?.station != nil {
                        Text("\(self.moerailData.query)").font(.headline)
                        Text("\(self.moerailData.emuList.first?.timetable.first?.station ?? "") ⇀ \(self.moerailData.emuList.first?.timetable.last?.station ?? "")").font(.caption2)
                    } else {
                        Text(self.moerailData.query).font(.headline)
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
