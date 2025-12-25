//
//  FavoritesView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var vm = FavoritesViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {

                Section(header: Text("车次")) {
                    if vm.favoriteTrains.isEmpty {
                        Text("您可以在查询时选择收藏某一特定车次（例如G2）。收藏后的车次将在这里显示其最新的运用信息。").font(.caption)
                    } else {
                        ForEach(vm.favoriteTrains, id: \.self) { emu in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(emu.freshnessColor)
                                    .frame(width: 8, height: 8)
                                EMUAndTrainRow(emuTrainAssoc: emu, path: $path, layoutStyle: .trainFirst)
                            }
                        }
                    }
                }
                Section(header: Text("动车组"), footer: Text("您也可以在主屏幕上添加“交路查询”小工具，不用打开 App 即可查看收藏列车和动车组的交路信息。")) {
                    if vm.favoriteEMUs.isEmpty {
                        Text("您可以在查询时选择收藏某一特定动车组（例如CRH2A2001）。收藏后的动车组将在这里显示其最新的运用信息。").font(.caption)
                    } else {
                        ForEach(vm.favoriteEMUs, id: \.self) { emu in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(emu.freshnessColor)
                                    .frame(width: 8, height: 8)
                                EMUAndTrainRow(emuTrainAssoc: emu, path: $path, layoutStyle: .emuFirst)
                            }
                        }
                    }
                }
                if !vm.favoriteTrains.isEmpty || !vm.favoriteEMUs.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Text("今天").fontWeight(.light)
                            }
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 8, height: 8)
                                Text("昨天").fontWeight(.light)
                            }
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                Text("前天及以前").fontWeight(.light)
                            }
                        }
                        .font(.caption)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onAppear(perform: {
                vm.refresh()
            })
            .queryNavigation(path: $path)
        }
    }
        
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
