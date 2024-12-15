//
//  TrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct TrainView: View {
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
            Spacer()
            Text(emu.date)
                .font(Font.caption.monospacedDigit())
        }
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainView(emu: EMU(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}
