//
//  EmptyView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct EmptyView: View {
    @State var query = ""
    @EnvironmentObject var moerailData: MoerailData
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("车次/车组，如 CRH2A2001", text: $query) { (_) in
                } onCommit: {
                    self.moerailData.getTrackingRecord(keyword: query)
                }.textFieldStyle(RoundedBorderTextFieldStyle())
                Button("搜索") {
                    self.moerailData.getTrackingRecord(keyword: query)
                }
            }
            
            Text("""
            提示：支持以下3种查询模式。
            [运用查询]: 您可以输入一个车次，如"G2"，来查询该车次的动车组运用信息。
            [交路查询]: 您可以输入一个车组号，如"CRH2A2001"，来查询该动车组的交路信息。
            [模糊查询]: 您可以输入一个，如"2A"，来查询所有编号内带有"2A"的动车运用信息。
            """).font(.caption2)
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("动车组交路查询")
                }
            }
        }
        .alert(isPresented: $moerailData.showEmptyAlert, content: {
            Alert(title: Text("搜索结果为空"), message: Text("可能尚未支持您想要查询车组所归属的路局。"))
        })
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
