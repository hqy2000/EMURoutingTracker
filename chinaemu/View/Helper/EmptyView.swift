//
//  EmptyView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI
import SFSafeSymbols
import AVFoundation
import CodeScanner
import PhotosUI

struct EmptyView: View {
    @State var query = ""
    @State var showActionSheet = false
    @EnvironmentObject var moerailData: MoerailData
    
    var body: some View {
        VStack(spacing: 10) {
            switch moerailData.mode {
            case .emptyEmu:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(moerailData.query)\"").foregroundColor(.gray)
                Button("上报相关信息") {
                    self.showActionSheet = true
                }
                .qrCodeActionSheet(showActionSheet: $showActionSheet) { url in
                    moerailData.postTrackingURL(url: url)
                }
            case .emptyTrain:
                Image(systemSymbol: .tram).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("暂未收录\"\(moerailData.query)\"\n可尝试搜索相关车组号").foregroundColor(.gray).multilineTextAlignment(.center)
            case .error:
                Image(systemSymbol: .multiply).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text(moerailData.errorMessage).foregroundColor(.gray)
            default:
                Image(systemSymbol: .magnifyingglass).resizable().aspectRatio(contentMode: .fit).frame(width: 30, height: 30, alignment: .center)
                Text("加载中")
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
} 
