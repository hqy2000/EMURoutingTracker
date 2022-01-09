//
//  SingleEMUView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import UIKit

struct SingleEMUListView: View {
    @EnvironmentObject var moerailData: MoerailData
    @State var overrideState: Bool? = nil
    var body: some View {
        List {
            ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                        EMUView(emu)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(moerailData.emuList.first?.image ?? "")
                    Text(moerailData.query).font(.headline)
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            QRView().environmentObject(self.moerailData)
            Button(action: {
                if !FavoritesProvider.shared.contains(emu: self.moerailData.emuList.first?.emu ?? "") {
                    FavoritesProvider.shared.add(emu: self.moerailData.emuList.first?.emu ?? "")
                    overrideState = true
                } else {
                    FavoritesProvider.shared.delete(emu: self.moerailData.emuList.first?.emu ?? "")
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
                    if !FavoritesProvider.shared.contains(emu: self.moerailData.emuList.first?.emu ?? "") {
                        Image(systemName: "star")
                    } else {
                        Image(systemName: "star.fill")
                    }
                }
                
            })
        })
    }
}

struct SingleEMUView_Previews: PreviewProvider {
    static var previews: some View {
        SingleEMUListView()
    }
}
