//
//  SingleEMUView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import UIKit

struct SingleEMUList: View {
    @EnvironmentObject var vm: EMUTrainViewModel
    @Binding var path: NavigationPath

    var body: some View {
        List {
            ForEach(vm.groupedByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(vm.groupedByDay[key] ?? [], id: \.id) { emu in
                        EMURow(emu: emu, path: $path)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(vm.emuTrainAssocList.first?.image ?? "").resizable().scaledToFit().frame(height: 28)
                    Text(vm.query).font(.headline)
                }
            }
        }
        .navigationBarItems(trailing: HStack {
            ScanQRCodeButton().environmentObject(self.vm)
            if let emu = vm.emuTrainAssocList.first?.emu {
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
