//
//  SingleTrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct TrainList: View {
    @EnvironmentObject var moerailData: MoerailData
    @Binding var path: NavigationPath
    @State var overrideState: Bool? = nil
    var body: some View {
        List {
            ForEach(moerailData.emuList, id: \.id) { emu in
                TrainRowView(emu: emu, path: $path)
            }
        }
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    if let trainInfo = self.moerailData.emuList.first?.trainInfo {
                        Text("\(self.moerailData.query)").font(.headline)
                        Text("\(trainInfo.from) ⇀ \(trainInfo.to)").font(.caption2)
                    } else {
                        Text(self.moerailData.query).font(.headline)
                    }
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            ScanQRCodeButton().environmentObject(self.moerailData)
            if let train = self.moerailData.emuList.first?.singleTrain {
                FavoriteButton(trainOrEMU: train, provider: FavoritesProvider.trains)
            }
            
        })
    }
}

struct SingleTrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainList(path: Binding.constant(NavigationPath()))
    }
}
