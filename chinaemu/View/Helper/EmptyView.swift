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
        HStack {
            
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
