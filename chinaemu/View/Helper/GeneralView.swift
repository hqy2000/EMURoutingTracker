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
            
            NavigationLink(
                destination: MoerailView(emu.train),
                tag: 2,
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
    
            Spacer(minLength: 0)
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Text(emu.train)
                        .font(.system(.callout, design: .monospaced))
                }
                HStack {
                    Spacer()
                    Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")").font(.system(.caption2, design: .monospaced))
                }
            }.onTapGesture {
                self.activeLink = 2
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(EMU(emu: "CRH2A2001", train: "G2", date: "2020-12-01"))
    }
}
