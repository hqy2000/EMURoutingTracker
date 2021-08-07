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
        HStack {
            Image(emu?.image ?? "").resizable().scaledToFit().frame(width: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(leftTicket.trainNo)
                    .font(Font.title3.monospacedDigit())
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
                            .font(Font.caption.monospacedDigit())
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
                            .font(Font.caption.monospacedDigit())
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
                    .font(Font.callout.monospacedDigit())
            }.frame(width: 90)
            
            Spacer()
            Image(systemName: "arrow.right")
            Spacer()
            VStack(alignment: .trailing) {
                Text(leftTicket.arrivalStation)
                    .font(.callout)
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(leftTicket.arrivalTime)
                    .font(Font.callout.monospacedDigit())
                    .fixedSize()
            }.frame(width: 90)
        }
    }
}

struct LeftTicketView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LeftTicketView(LeftTicket(departureTime: "12:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海虹桥", trainNo: "G1245", softSeat: "--", hardSeat: "--", softSleeper: "--", hardSleeper: "--", specialClass: "--", businessClass: "0", firstClass: "10", secondClass: "324", noSeat: "12"), EMU(emu: "CRH2A2001325", train: "G123", date: "2020-12-21"))
            LeftTicketView(LeftTicket(departureTime: "06:00", departureStation: "南京fh  南", arrivalTime: "12:59", arrivalStation: "上海  虹桥", trainNo: "Z1245", softSeat: "--", hardSeat: "--", softSleeper: "--", hardSleeper: "--", specialClass: "--", businessClass: "0", firstClass: "10", secondClass: "324", noSeat: "12"))
        }
    
    }
}
