//
//  SingleEMUView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import UIKit

struct SingleEMUList: View {
    @EnvironmentObject var moerailData: MoerailData
    @Binding var path: NavigationPath
    @State var overrideState: Bool? = nil
    var body: some View {
        List {
            ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                        EMURowView(emu: emu, path: $path)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(moerailData.emuList.first?.image ?? "").resizable().scaledToFit().frame(height: 28)
                    Text(moerailData.query).font(.headline)
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            ScanQRCodeButton().environmentObject(self.moerailData)
            if let emu = moerailData.emuList.first?.emu {
                FavoriteButton(trainOrEMU: emu, provider: FavoritesProvider.EMUs)
            }
        })
    }
}

struct SingleEMUView_Previews: PreviewProvider {
    static var previews: some View {
        SingleEMUList(path: Binding.constant(NavigationPath()))
    }
}
