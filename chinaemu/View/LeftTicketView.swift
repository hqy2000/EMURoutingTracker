//
//  LeftTicketView.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct LeftTicketView: View {
    @State var showDetails: Bool = false
    
    @Binding var path: NavigationPath
    let leftTicket: LeftTicket
    let emu: EMU?

    var body: some View {
        HStack(spacing: 0) {
            Image(emu?.image ?? "").resizable().scaledToFit().frame(width: 20, alignment: .leading)
            Spacer().frame(minWidth: 3, maxWidth: 20)
            VStack(alignment: .leading) {
                Button {
                    path.append(Query.trainOrEmu(trainOrEmu: leftTicket.trainNo))
                } label: {
                    Text(leftTicket.trainNo)
                        .font(.system(.title3, design: .monospaced))
                }.buttonStyle(.borderless)
                .frame(width: 100, alignment: .leading)

                if !leftTicket.isEMU {
                    Text("非动车组")
                        .foregroundColor(.gray)
                        .font(Font.caption)
                } else if let emu = emu {
                    Button {
                        path.append(Query.trainOrEmu(trainOrEmu: emu.emu))
                    } label: {
                        Text(emu.emu)
                            .lineLimit(1)
                            .foregroundColor(emu.color)
                            .fixedSize()
                            .font(.system(.caption, design: .monospaced))
                    }.buttonStyle(.borderless)
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
            LeftTicketView(path: Binding.constant(NavigationPath()), leftTicket: LeftTicket(departureTime: "12:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海虹桥", trainNo: "G1245"), emu: EMU(emu: "CRH2A2001325", train: "G123", date: "2020-12-21"))
            LeftTicketView(path: Binding.constant(NavigationPath()), leftTicket: LeftTicket(departureTime: "06:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海  虹桥", trainNo: "Z1245"), emu: nil)
        }
    }
}
