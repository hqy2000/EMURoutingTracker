//
//  EMUView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/15/20.
//

import SwiftUI

struct EMUView: View {
    @State var activeLink: Int? = nil
    @Binding var path: NavigationPath
    let emu: EMU
    
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
        EMUView(path: Binding.constant(NavigationPath()), emu: EMU(emu: "a", train: "a", date: "a"))
    }
}
