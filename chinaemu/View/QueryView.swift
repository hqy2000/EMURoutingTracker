//
//  QueryView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftUI

struct QueryView: View {
    @State var query = ""
    var body: some View {
        List {
            Section(header: Text("车组号/车次查询")) {
                HStack {
                    TextField("CRH2A2001", text: $query)
//                    } onCommit: {
//                        self.moerailData.getTrackingRecord(keyword: query)
//                    }.textFieldStyle(RoundedBorderTextFieldStyle())
                    NavigationLink(
                        destination: MoerailView(query),
                        label: {
                            Text("搜索")
                        }).frame(width: 70)
                }
            }
//            Section(header: Text("发着查询")) {
//                HStack {
//                    VStack {
//
//                    }
//                }
//            }
        }.listStyle(InsetGroupedListStyle())
        
    }
}
