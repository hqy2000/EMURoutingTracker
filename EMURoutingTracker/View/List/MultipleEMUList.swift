//
//  MultipleEMUsView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct MultipleEMUList: View {
    @EnvironmentObject var vm: EMUTrainViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(vm.groupedByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(vm.groupedByDay[key] ?? [], id: \.id) { emu in
                        EMUAndTrainRow(emuTrainAssoc: emu, path: $path)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(vm.query).font(.headline)
                }
            }
        }
    }
}

struct MultipleEMUsView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleEMUList(path: Binding.constant(NavigationPath()))
    }
}
