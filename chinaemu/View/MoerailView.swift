//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct MoerailView: View {
    @ObservedObject var moerailData = MoerailData()
    let query: String
    init(_ query: String = "") {
        self.query = query
    }
    
    var body: some View {
        HStack {
            if moerailData.mode == .empty || moerailData.emuList.isEmpty {
                EmptyView().environmentObject(moerailData)
            } else if moerailData.mode == .singleEmu {
                SingleEMUListView().environmentObject(moerailData)
            } else if moerailData.mode == .singleTrain {
                SingleTrainListView().environmentObject(moerailData)
            } else if moerailData.mode == .multipleEmus {
                MultipleEMUsListView().environmentObject(moerailData)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.moerailData.getTrackingRecord(keyword: query)
        })
        
    }
}

struct MoerailView_Previews: PreviewProvider {
    static var previews: some View {
        MoerailView()
    }
}
