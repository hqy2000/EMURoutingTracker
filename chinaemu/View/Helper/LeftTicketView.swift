//
//  LeftTicketView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct LeftTicketView: View {
    @State var activeLink: Int? = nil
    @State var showDetails: Bool = false
    let leftTicket: LeftTicket
    let emu: EMU?
    
    init(_ leftTicket: LeftTicket, _ emu: EMU? = nil) {
        self.leftTicket = leftTicket
        self.emu = emu
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(emu?.image ?? "").resizable().scaledToFit().frame(width: 20, alignment: .leading)
            Spacer().frame(minWidth: 3, maxWidth: 20)
            VStack(alignment: .leading) {
                Text(leftTicket.trainNo)
                    .font(.system(.title3, design: .monospaced))
                    .frame(width: 100, alignment: .leading)
                    .onTapGesture {
                        self.activeLink = 2
                    }
                if !leftTicket.isEMU {
                    Text("非动车组")
                        .foregroundColor(.gray)
                        .font(Font.caption)
                } else if let emu = emu {
                    HStack {
                        Text(emu.emu)
                            .lineLimit(1)
                            .foregroundColor(emu.color)
                            .fixedSize()
                            .font(.system(.caption, design: .monospaced))
                            .onTapGesture {
                                self.activeLink = 1
                            }
                    }
                } else {
                    HStack {
                        Text("未知")
                            .lineLimit(1)
                            .foregroundColor(.gray)
                            .fixedSize()
                            .font(.system(.caption, design: .monospaced))
                    }
                }
            }
            
            if let emu = emu {
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
            }
            
            
            VStack(alignment: .leading) {
                Text(leftTicket.departureStation)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(leftTicket.departureTime)
                    .font(.system(.callout, design: .monospaced))
            }.frame(width: 90)
            
            Spacer(minLength: 3)
            Image(systemName: "arrow.right")
            Spacer(minLength: 3)
            VStack(alignment: .trailing) {
                Text(leftTicket.arrivalStation)
                    .font(.callout)
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(leftTicket.arrivalTime)
                    .font(.system(.callout, design: .monospaced))
                    .fixedSize()
            }.frame(width: 90)
        }
    }
}

struct LeftTicketView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LeftTicketView(LeftTicket(departureTime: "12:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海虹桥", trainNo: "G1245"/*, softSeat: "--", hardSeat: "--", softSleeper: "--", hardSleeper: "--", specialClass: "--", businessClass: "0", firstClass: "10", secondClass: "324", noSeat: "12"*/), EMU(emu: "CRH2A2001325", train: "G123", date: "2020-12-21"))
            LeftTicketView(LeftTicket(departureTime: "06:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海  虹桥", trainNo: "Z1245"/*, softSeat: "--", hardSeat: "--", softSleeper: "--", hardSleeper: "--", specialClass: "--", businessClass: "0", firstClass: "10", secondClass: "324", noSeat: "12"*/))
        }
    
    }
}
