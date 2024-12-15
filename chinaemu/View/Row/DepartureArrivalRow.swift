//
//  DepartureArrivalRow.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import SwiftUI

struct DepartureArrivalRow: View {
    @State var showDetails: Bool = false
    
    @Binding var path: NavigationPath
    let departureArrival: DepartureArrival
    let emu: EMUTrainAssociation?

    var body: some View {
        HStack(spacing: 0) {
            Image(emu?.image ?? "").resizable().scaledToFit().frame(width: 20, alignment: .leading)
            Spacer().frame(minWidth: 3, maxWidth: 20)
            VStack(alignment: .leading) {
                Button {
                    path.append(Query.trainOrEmu(trainOrEmu: departureArrival.trainNo))
                } label: {
                    Text(departureArrival.trainNo)
                        .font(.system(.title3, design: .monospaced))
                }.buttonStyle(.borderless)
                .frame(width: 100, alignment: .leading)

                if !departureArrival.isEMU {
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
                Text(departureArrival.departureStation)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(departureArrival.departureTime)
                    .font(.system(.callout, design: .monospaced))
            }.frame(width: 90)
            
            Spacer(minLength: 3)
            Image(systemName: "arrow.right")
            Spacer(minLength: 3)
            VStack(alignment: .trailing) {
                Text(departureArrival.arrivalStation)
                    .font(.callout)
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(departureArrival.arrivalTime)
                    .font(.system(.callout, design: .monospaced))
                    .fixedSize()
            }.frame(width: 90)
        }
    }
}

struct DepartureArrivalRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DepartureArrivalRow(path: Binding.constant(NavigationPath()), departureArrival: DepartureArrival(departureTime: "12:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海虹桥", trainNo: "G1245"), emu: EMUTrainAssociation(emu: "CRH2A2001325", train: "G123", date: "2020-12-21"))
            DepartureArrivalRow(path: Binding.constant(NavigationPath()), departureArrival: DepartureArrival(departureTime: "06:00", departureStation: "南京南", arrivalTime: "12:59", arrivalStation: "上海  虹桥", trainNo: "Z1245"), emu: nil)
        }
    }
}
