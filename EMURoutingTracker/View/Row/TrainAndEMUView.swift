//
//  GeneralView.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct TrainAndEMUView: View {
    let emuTrainAssoc: EMUTrainAssociation
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(emuTrainAssoc.train)
                    .font(.system(.callout, design: .monospaced))
                    .foregroundStyle(.blue)
                if let trainInfo = emuTrainAssoc.trainInfo {
                    Text("\(trainInfo.from) ⇀ \(trainInfo.to)").font(.system(.caption2, design: .monospaced))
                } else {
                    ProgressView()
                }
            }
            .onTapGesture {
                path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.train))
            }
            
            Spacer(minLength: 0)
            
            
            Text(emuTrainAssoc.emu)
                .foregroundColor(emuTrainAssoc.color)
                .font(.system(.body, design: .monospaced))
                .onTapGesture {
                    path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.emu))
                }
            
            Image(emuTrainAssoc.image).resizable().scaledToFit().frame(height: 28)
           
            
        }
    }
}

#Preview {
    EMUAndTrainRow(emuTrainAssoc: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
}
