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
    
    init(_ emu: EMU) {
        self.emu = emu
    }
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: MoerailView(emu.train),
                tag: 1,
                selection: $activeLink) {}
                .frame(width: 0)
                .hidden()
            Text(emu.train)
                .font(Font.body.monospacedDigit())
                .onTapGesture {
                    self.activeLink = 1
                }
            Spacer()
            
            if emu.timetable.first?.station != nil {
                Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")")
            } else {
                ProgressView()
            }
        }
    }
}

struct EMUView_Previews: PreviewProvider {
    static var previews: some View {
        EMUView(EMU(emu: "a", train: "a", date: "a"))
    }
}
