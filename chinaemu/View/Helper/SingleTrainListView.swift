//
//  SingleTrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct SingleTrainListView: View {
    @EnvironmentObject var moerailData: MoerailData
    @Binding var path: NavigationPath
    @State var overrideState: Bool? = nil
    var body: some View {
        List {
            ForEach(moerailData.emuList, id: \.id) { emu in
                TrainView(emu: emu, path: $path)
            }
        }
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    if self.moerailData.emuList.first?.trainInfo?.from != nil {
                        Text("\(self.moerailData.query)").font(.headline)
                        Text("\(self.moerailData.emuList.first?.trainInfo?.from ?? "") ⇀ \(self.moerailData.emuList.first?.trainInfo?.to ?? "")").font(.caption2)
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
        SingleTrainListView(path: Binding.constant(NavigationPath()))
    }
}
