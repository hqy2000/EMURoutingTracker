//
//  EmptyView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct EmptyRow: View {
    @State var query = ""
    @State var showActionSheet = false
    @Binding var path: NavigationPath
    @EnvironmentObject var vm: EMUTrainViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            switch vm.mode {
            case .emptyEmu:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(vm.query)\"").foregroundColor(.gray)
                Button("上报相关信息") {
                    self.showActionSheet = true
                }
                .scanQrCodeActionSheet(isPresented: $showActionSheet) { url in
                    vm.postTrackingURL(url: url)
                }
            case .emptyTrain:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(vm.query)\"\n可尝试搜索相关车组号").foregroundColor(.gray).multilineTextAlignment(.center)
            case .error:
                Image(systemSymbol: .multiply).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text(vm.errorMessage).foregroundColor(.gray)
            default:
                Image(systemSymbol: .magnifyingglass).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("加载中")
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRow(path: Binding.constant(NavigationPath()))
    }
} 
