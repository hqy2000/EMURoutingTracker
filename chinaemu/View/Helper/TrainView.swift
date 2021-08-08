//
//  TrainView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct TrainView: View {
    @State var activeLink: Int? = nil
    let emu: EMU
    
    init(_ emu: EMU) {
        self.emu = emu
    }
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: MoerailView(emu.emu),
                tag: 1,
                selection: $activeLink) {}
                .frame(width: 0)
                .hidden()
            Image(emu.image)
            Text(emu.emu)
                .foregroundColor(emu.color)
                .font(.system(.body, design: .monospaced))
                .onTapGesture {
                    self.activeLink = 1
                }
            Spacer()
            Text(emu.date)
                .font(Font.caption.monospacedDigit())
        }
    }
}

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        TrainView(EMU(emu: "CRH2A2001", train: "G2", date: "2020-12-01"))
    }
}
