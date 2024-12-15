//
//  EMUView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct EMUView: View {
    @State var activeLink: Int? = nil
    let emu: EMU
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Button {
                path.append(Query.trainOrEmu(trainOrEmu: emu.train))
            } label: {
                Text(emu.train).font(.system(.body, design: .monospaced))
            }

            Spacer()
            
            if emu.trainInfo?.from != nil {
                Text("\(emu.trainInfo?.from ?? "") ⇀ \(emu.trainInfo?.to ?? "")")
            } else {
                ProgressView()
            }
        }
    }
}

struct EMUView_Previews: PreviewProvider {
    static var previews: some View {
        EMUView(emu: EMU(emu: "a", train: "a", date: "a"), path: Binding.constant(NavigationPath()))
    }
}
