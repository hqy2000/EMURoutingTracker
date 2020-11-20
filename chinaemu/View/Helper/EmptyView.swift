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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack {
            
        }.alert(isPresented: $moerailData.showEmptyAlert, content: {
            Alert(title: Text("搜索结果为空"), message: Text("可能尚未支持您想要查询车组所归属的路局。"), dismissButton: Alert.Button.default(Text("OK"), action: {
                
                    self.presentationMode.wrappedValue.dismiss()
                
            }))
        })
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
