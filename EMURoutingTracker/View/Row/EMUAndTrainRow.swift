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
    let layoutStyle: LayoutStyle
    
    enum LayoutStyle {
        case emuFirst
        case trainFirst
    }
    
    var body: some View {
        HStack {
            HStack {
                Image(emuTrainAssoc.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                
                Text(emuTrainAssoc.emu)
                    .foregroundColor(emuTrainAssoc.color)
                    .font(.system(.body, design: .monospaced))
                    .onTapGesture {
                        path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.emu))
                    }
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 4) {
                Text(emuTrainAssoc.train)
                    .font(.system(.callout, design: .monospaced))
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        path.append(Query.trainOrEmu(trainOrEmu: emuTrainAssoc.train))
                    }
                if let trainInfo = emuTrainAssoc.trainInfo {
                    Text("\(trainInfo.from) ⇀ \(trainInfo.to)")
                        .font(.system(.caption2, design: .monospaced))
                } else {
                    ProgressView()
                }
            }
        }
        .environment(\.layoutDirection, layoutStyle == .emuFirst ? .leftToRight : .rightToLeft)
    }
}

#Preview {
    EMUAndTrainRow(
        emuTrainAssoc: EMUTrainAssociation(
            emu: "CRH2A2001",
            train: "G2",
            date: "2020-12-01"
        ),
        path: Binding.constant(NavigationPath()),
        layoutStyle: .emuFirst
    )
    
    EMUAndTrainRow(
        emuTrainAssoc: EMUTrainAssociation(
            emu: "CRH2A2001",
            train: "G2",
            date: "2020-12-01"
        ),
        path: Binding.constant(NavigationPath()),
        layoutStyle: .trainFirst
    )
}
