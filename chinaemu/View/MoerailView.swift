//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct MoerailView: View {
    @ObservedObject var moerailData = MoerailData()
    @ObservedObject var crData = CRData()
    @State var query = "G2"
    
    var body: some View {
        List {
            ForEach(moerailData.groupedByTime.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupedByTime[key] ?? [], id: \.id) { emu in
                        HStack {
                            if moerailData.isTrain {
                                Image("CRH2A")
                                Text(emu.emu)
                                    .font(Font.body.monospacedDigit())
                                Spacer()
                            } else {
                                Text(emu.train)
                                    .font(Font.body.monospacedDigit())
                                Spacer()
                                Text("\(crData.timetables[emu.train + emu.date]?.first?.station ?? "") ⇀ \(crData.timetables[emu.train + emu.date]?.last?.station ?? "")")
                            }
                            
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            moerailData.startAppRefresh()
            moerailData.getTrackingRecord(keyword: "G4") {
                for emu in moerailData.emuList {
                    crData.getTimetable(trainNo: emu.train, date: emu.date) {
                        
                    }
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if moerailData.isTrain {
                    HStack {
                        Text(self.moerailData.query + "\(crData.timetables[self.moerailData.query]?.first?.station ?? "") ⇀ \(crData.timetables[self.moerailData.query]?.last?.station ?? "")").font(.headline)
                    }
                } else {
                    HStack {
                        Image("CRH2A")
                        Text("CRH2A 2001").font(.headline)
                    }
                }
                
            }
        }
        //.navigationBarItems(leading: )
        
    }
}

struct MoerailView_Previews: PreviewProvider {
    static var previews: some View {
        MoerailView()
    }
}
