//
//  GeneralView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct EMUAndTrainRow: View {
    @State var activeLink: Int? = nil
    let emuTrainAssoc: EMUTrainAssociation
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Image(emuTrainAssoc.image).resizable().scaledToFit().frame(height: 28)
            
            Button {
                path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.emu))
            } label: {
                Text(emuTrainAssoc.emu)
                    .foregroundColor(emuTrainAssoc.color)
                    .font(.system(.body, design: .monospaced))
            }
            
            
            Spacer(minLength: 0)
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Button {
                        path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.train))
                    } label: {
                        Text(emuTrainAssoc.train)
                            .font(.system(.callout, design: .monospaced))
                    }
                }
                HStack {
                    Spacer()
                    if let trainInfo = emuTrainAssoc.trainInfo {
                        Text("\(trainInfo.from) ⇀ \(trainInfo.to)").font(.system(.caption2, design: .monospaced))
                    }
                }
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        EMUAndTrainRow(emuTrainAssoc: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}
