//
//  GeneralView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct EMUAndTrainRow: View {
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
            
            VStack(alignment: .trailing, spacing: 4) {
                Button {
                    path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.train))
                } label: {
                    Text(emuTrainAssoc.train)
                        .font(.system(.callout, design: .monospaced))
                }
                if let trainInfo = emuTrainAssoc.trainInfo {
                    Text("\(trainInfo.from) ⇀ \(trainInfo.to)").font(.system(.caption2, design: .monospaced))
                } else {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    EMUAndTrainRow(emuTrainAssoc: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
}
