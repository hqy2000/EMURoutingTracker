//
//  MultipleEMUsView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct MultipleEMUsListView: View {
    @EnvironmentObject var moerailData: MoerailData
    @Binding var path: NavigationPath
    
    var body: some View {
        List {
            ForEach(moerailData.groupByDay.keys.sorted().reversed(), id: \.self) { key in
                Section(header: Text(key)) {
                    ForEach(moerailData.groupByDay[key] ?? [], id: \.id) { emu in
                        GeneralView(emu: emu, path: $path)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(moerailData.query).font(.headline)
                }
            }
        }
    }
}

struct MultipleEMUsView_Previews: PreviewProvider {
    static var previews: some View {
        MultipleEMUsListView(path: Binding.constant(NavigationPath()))
    }
}
