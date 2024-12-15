//
//  MoerailView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import SwiftUI

struct TrainOrEMUView: View {
    @ObservedObject var moerailData = MoerailData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let query: String
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            if moerailData.mode == .singleEmu {
                SingleEMUList(path: $path).environmentObject(moerailData)
            } else if moerailData.mode == .singleTrain {
                TrainList(path: $path).environmentObject(moerailData)
            } else if moerailData.mode == .multipleEmus {
                MultipleEMUList(path: $path).environmentObject(moerailData)
            } else {
                EmptyRowView(path: $path).environmentObject(moerailData)
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
        TrainOrEMUView(query: "380", path: Binding.constant(NavigationPath()))
    }
}
