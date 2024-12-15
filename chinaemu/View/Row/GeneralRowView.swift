//
//  GeneralView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct GeneralRowView: View {
    @State var activeLink: Int? = nil
    let emu: EMUTrainAssociation
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Image(emu.image).resizable().scaledToFit().frame(height: 28)
            
            Button {
                path.append(Query.trainOrEmu(trainOrEmu: emu.emu))
            } label: {
                Text(emu.emu)
                    .foregroundColor(emu.color)
                    .font(.system(.body, design: .monospaced))
            }
            
            
            Spacer(minLength: 0)
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Button {
                        path.append(Query.trainOrEmu(trainOrEmu: emu.train))
                    } label: {
                        Text(emu.train)
                            .font(.system(.callout, design: .monospaced))
                    }
                }
                HStack {
                    Spacer()
                    if let trainInfo = emu.trainInfo {
                        Text("\(trainInfo.from) ⇀ \(trainInfo.to)").font(.system(.caption2, design: .monospaced))
                    }
                }
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralRowView(emu: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}