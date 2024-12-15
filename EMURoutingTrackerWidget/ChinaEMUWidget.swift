//
//  EMURoutingTrackerWidget.swift
//  EMURoutingTrackerWidget
//
//  Created by Qingyang Hu on 11/22/20.
//

import WidgetKit
import SwiftUI
import Intents
import EMURoutingTrackerFramework

struct Provider: TimelineProvider {
    let vm = FavoritesViewModel()
    func placeholder(in context: Context) -> FavoritesEntry {
        let entry = FavoritesEntry(date: Date(), favoriteTrains: [EMUTrainAssociation(emu: "CRH2C2001", train: "D0001", date: "20210102")], favoriteEmus: [EMUTrainAssociation(emu: "CR400AF0001", train: "G1", date: "20210102")])
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (FavoritesEntry) -> ()) {
        vm.refresh {
            let entry = FavoritesEntry(date: Date(), favoriteTrains: vm.favoriteTrains, favoriteEmus: vm.favoriteEMUs)
            completion(entry)
        }
    }

    func getTimeline( in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        vm.refresh {
            let entry = FavoritesEntry(date: Date(), favoriteTrains: vm.favoriteTrains, favoriteEmus: vm.favoriteEMUs)
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!

            let timeline = Timeline(
               entries: [entry],
               policy: .after(nextUpdateDate)
            )

            completion(timeline)
        }
        
    }
}

struct FavoritesEntry: TimelineEntry {
    var date: Date
    var favoriteTrains: [EMUTrainAssociation]
    var favoriteEmus: [EMUTrainAssociation]
}

struct WidgetSingleColumnEntryView : View {
    var entry: FavoritesEntry
    var body: some View {
        HStack(alignment: .center,spacing: 0) {
            if entry.favoriteTrains.isEmpty && entry.favoriteEmus.isEmpty {
                Text("请先在 App 内添加相关收藏").padding().multilineTextAlignment(.center).foregroundColor(.gray).font(.caption)
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(entry.favoriteTrains.prefix(4), id: \.self) { emu in
                        EMUView(emu)
                    }
                    Divider()
                    ForEach(entry.favoriteEmus.prefix(4), id: \.self) { emu in
                        TrainView(emu)
                    }
                }.padding(8)
            }
        }
        
        
    }
}


struct EMUView: View {
    let emu: EMUTrainAssociation
    
    init(_ emu: EMUTrainAssociation) {
        self.emu = emu
    }
    var body: some View {
        HStack {
            Text(emu.shortName)
                .foregroundColor(emu.color)
                .font(.system(.caption2, design: .monospaced))
            Spacer()
            Image(emu.image).resizable().scaledToFit().frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.leading, 1).padding(.trailing, -6)
            Text(emu.shortTrain)
                .font(.system(.caption2, design: .monospaced))
        }
    }
}

struct TrainView: View {
    let train: EMUTrainAssociation
    
    init(_ train: EMUTrainAssociation) {
        self.train = train
    }
    var body: some View {
        HStack {
            Image(train.image).resizable().scaledToFit().frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.leading, 1).padding(.trailing, -6)
            Text(train.shortTrain)
                .font(.system(.caption2, design: .monospaced))
            Spacer()
            Text(train.shortName)
                .foregroundColor(train.color)
                .font(.system(.caption2, design: .monospaced))
        }
    }
}




@main
struct EMURoutingTrackerWidget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetSingleColumnEntryView(entry: entry)
        }
        .configurationDisplayName("收藏列车实时交路")
        .description("展示收藏的列车或车组的实时交路信息。")
        .supportedFamilies([.systemSmall])
    }
}

struct EMURoutingTrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSingleColumnEntryView(entry: FavoritesEntry(date: Date(), favoriteTrains: [EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101")], favoriteEmus: [EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101"), EMUTrainAssociation(emu: "CRH2A0000", train: "D1323/1231", date: "20210101")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
