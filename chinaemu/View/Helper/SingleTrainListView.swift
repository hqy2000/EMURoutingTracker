//
//  SingleTrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct SingleTrainListView: View {
    @EnvironmentObject var moerailData: MoerailData
    @State var overrideState: Bool? = nil
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
        .navigationBarItems(trailing: HStack{
            QRView().environmentObject(self.moerailData)
            Button(action: {
                if !FavoritesProvider.shared.contains(train: self.moerailData.emuList.first?.singleTrain ?? "") {
                    FavoritesProvider.shared.add(train: self.moerailData.emuList.first?.singleTrain ?? "")
                    overrideState = true
                } else {
                    FavoritesProvider.shared.delete(train: self.moerailData.emuList.first?.singleTrain ?? "")
                    overrideState = false
                }
            }, label: {
                if let state = self.overrideState {
                    if !state {
                        Image(systemName: "star")
                    } else {
                        Image(systemName: "star.fill")
                    }
                } else {
                    if !FavoritesProvider.shared.contains(train: self.moerailData.emuList.first?.singleTrain ?? "") {
                        Image(systemName: "star")
                    } else {
                        Image(systemName: "star.fill")
                    }
                }
                
            })
        }
        )
    }
}

struct SingleTrainView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTrainListView()
    }
}
