//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct MoerailView: View {
    @ObservedObject var moerailData = MoerailData()
    
    var body: some View {
        HStack {
            if moerailData.mode == .empty || moerailData.emuList.isEmpty {
                EmptyView().environmentObject(moerailData)
            } else if moerailData.mode == .singleEmu {
                SingleEMUView().environmentObject(moerailData)
            } else if moerailData.mode == .singleTrain {
                SingleTrainView().environmentObject(moerailData)
            } else if moerailData.mode == .multipleEmus {
                MultipleEMUsView().environmentObject(moerailData)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MoerailView_Previews: PreviewProvider {
    static var previews: some View {
        MoerailView()
    }
}
