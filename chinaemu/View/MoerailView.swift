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
        .alert(isPresented: $moerailData.showEmptyAlert, content: {
            Alert(title: Text("搜索结果为空"), message: Text("可能尚未支持您想要查询车组所归属的路局。"), dismissButton: Alert.Button.default(Text("OK"), action: {
                
                    self.presentationMode.wrappedValue.dismiss()
                
            }))
        })
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
