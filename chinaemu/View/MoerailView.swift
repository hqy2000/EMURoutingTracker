//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct MoerailView: View {
    @ObservedObject var moerailData = MoerailData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let query: String
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            if moerailData.mode == .singleEmu {
                SingleEMUListView(path: $path).environmentObject(moerailData)
            } else if moerailData.mode == .singleTrain {
                SingleTrainListView(path: $path).environmentObject(moerailData)
            } else if moerailData.mode == .multipleEmus {
                MultipleEMUsListView(path: $path).environmentObject(moerailData)
            } else {
                EmptyView(path: $path).environmentObject(moerailData)
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
        MoerailView(query: "380", path: Binding.constant(NavigationPath()))
    }
}
