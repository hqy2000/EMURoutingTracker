//
//  TrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct TrainRowView: View {
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
            Spacer()
            Text(emu.date)
                .font(Font.caption.monospacedDigit())
        }
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainRowView(emu: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}
