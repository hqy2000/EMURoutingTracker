//
//  EMUView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct EMURow: View {
    @State var activeLink: Int? = nil
    let emu: EMUTrainAssociation
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Button {
                path.append(Query.trainOrEmu(trainOrEmu: emu.train))
            } label: {
                Text(emu.train).font(.system(.body, design: .monospaced))
            }

            Spacer()
            
            if let trainInfo = emu.trainInfo {
                Text("\(trainInfo.from) ⇀ \(trainInfo.to)")
            } else {
                ProgressView()
            }
        }
    }
}

struct EMUView_Previews: PreviewProvider {
    static var previews: some View {
        EMURow(emu: EMUTrainAssociation(emu: "a", train: "a", date: "a"), path: Binding.constant(NavigationPath()))
    }
}
