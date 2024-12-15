//
//  TrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct TrainRow: View {
    let train: EMUTrainAssociation
    @Binding var path: NavigationPath
    
    var body: some View {
        HStack {
            Image(train.image).resizable().scaledToFit().frame(height: 28)
            Button {
                path.append(Query.trainOrEmu(trainOrEmu: train.emu))
            } label: {
                Text(train.emu)
                    .foregroundColor(train.color)
                    .font(.system(.body, design: .monospaced))
            }
            Spacer()
            Text(train.date)
                .font(Font.caption.monospacedDigit())
        }
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainRow(train: EMUTrainAssociation(emu: "CRH2A2001", train: "G2", date: "2020-12-01"), path: Binding.constant(NavigationPath()))
    }
}
