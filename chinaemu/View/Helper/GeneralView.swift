//
//  GeneralView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct GeneralView: View {
    @State var activeLink: Int? = nil
    let emu: EMU
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Image(emu.image)
            
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
                    Text(emu.train)
                        .font(.system(.callout, design: .monospaced))
                }
                HStack {
                    Spacer()
                    Text("\(emu.trainInfo?.from ?? "") ⇀ \(emu.trainInfo?.to ?? "")").font(.system(.caption2, design: .monospaced))
                }
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(emu: EMU(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}
