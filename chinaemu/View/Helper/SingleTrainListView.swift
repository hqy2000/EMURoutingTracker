//
//  SingleTrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct SingleTrainListView: View {
    @EnvironmentObject var moerailData: MoerailData
    var body: some View {
        List {
            ForEach(moerailData.emuList, id: \.id) { emu in
                TrainView(emu)
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

    }
}

struct SingleTrainView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTrainListView()
    }
}
