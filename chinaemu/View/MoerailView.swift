//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct MoerailView: View {
    @ObservedObject var moerailData = MoerailData()
    @State var query = "G2"
    
    var body: some View {
        List {
            if moerailData.mode == .singleEmu {
                ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                    Section(header: Text(key)) {
                        ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                            HStack {
                                Text(emu.train)
                                    .font(Font.body.monospacedDigit())
                                Spacer()
                                Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")")
                            }
                        }
                    }
                }
            } else if moerailData.mode == .singleTrain {
                ForEach(moerailData.emuList, id: \.id) { emu in
                    HStack {
                        Image("CRH2A")
                        Text(emu.emu)
                            .font(Font.body.monospacedDigit())
                        Spacer()
                        Text(emu.date)
                            .font(Font.caption.monospacedDigit())
                    }
                }
            } else if moerailData.mode == .multipleEmus {
                ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                    Section(header: Text(key)) {
                        ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                            HStack {
                                Image("CRH2A")
                                Text(emu.emu)
                                    .font(Font.body.monospacedDigit())
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
                                }
                                
                            }
                        }
                    }
                }
            }
        
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            moerailData.getTrackingRecord(keyword: "2A")
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if moerailData.mode == .singleTrain {
                    HStack {
                        Text(self.moerailData.query + " \(self.moerailData.emuList.first?.timetable.first?.station ?? "") ⇀ \(self.moerailData.emuList.first?.timetable.last?.station ?? "")").font(.headline)
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
