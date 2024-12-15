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
        .navigationBarItems(trailing: HStack {
            QRView().environmentObject(self.moerailData)
            if let train = self.moerailData.emuList.first?.singleTrain {
                FavoriteStarView(trainOrEMU: train, provider: FavoritesProvider.trains)
            }
            
        })
    }
}

struct SingleTrainView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTrainListView(path: Binding.constant(NavigationPath()))
    }
}
