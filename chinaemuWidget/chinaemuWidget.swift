//
//  widget.swift
//  widget
//
//  Created by Qingyang Hu on 11/22/20.
//

import WidgetKit
import SwiftUI
import Intents
import chinaemuFramework

struct Provider: TimelineProvider {
    let favoriteData = FavoritesData()
    func placeholder(in context: Context) -> FavoritesEntry {
        let entry = FavoritesEntry(date: Date(), favoriteTrains: [EMU(emu: "CRH2C2001", train: "D0001", date: "20210102")], favoriteEmus: [EMU(emu: "CR400AF0001", train: "G1", date: "20210102")])
        return entry
    }

    func getSnapshot(in context: Context, completion: @escaping (FavoritesEntry) -> ()) {
        favoriteData.refresh {
            print("snapshot")
            dump(favoriteData.favoriteTrains)
            let entry = FavoritesEntry(date: Date(), favoriteTrains: favoriteData.favoriteTrains, favoriteEmus: favoriteData.favoriteEMUs)
            completion(entry)
        }
    }

    func getTimeline( in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        favoriteData.refresh {
            print("snapshot")
            let entry = FavoritesEntry(date: Date(), favoriteTrains: favoriteData.favoriteTrains, favoriteEmus: favoriteData.favoriteEMUs)
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date())!

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
    var favoriteTrains: [EMU]
    var favoriteEmus: [EMU]
}

struct WidgetSingleColumnEntryView : View {
    var entry: FavoritesEntry
    var body: some View {
        HStack(alignment: .center,spacing: 0) {
            if entry.favoriteTrains.isEmpty && entry.favoriteEmus.isEmpty {
                Text("请先在 App 内添加相关收藏。")
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(entry.favoriteTrains.prefix(4), id: \.self) { emu in
                        EMUView(emu)
                    }
                }.padding(3)
                Divider()
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(entry.favoriteEmus.prefix(4), id: \.self) { emu in
                        TrainView(emu)
                    }
                }.padding(3)
            }
        }
        
        
    }
}

struct EMUView: View {
    let emu: EMU
    
    init(_ emu: EMU) {
        self.emu = emu
    }
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack {
                Text(emu.shortName)
                    .foregroundColor(emu.color)
                    .font(Font.caption2.monospacedDigit())
            }
            HStack {
                Image(emu.image).resizable().scaledToFit().frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.leading, 0.5).padding(.trailing, -5)
                Text(emu.train)
                    .font(Font.caption2.monospacedDigit())
            }
        }
    }
}

struct TrainView: View {
    let emu: EMU
    
    init(_ emu: EMU) {
        self.emu = emu
    }
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack {
                Image(emu.image).resizable().scaledToFit().frame(height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding(.leading, 0.5).padding(.trailing, -5)
                Text(emu.train)
                    .font(Font.caption2.monospacedDigit())
            }
            HStack {
                Text(emu.shortName)
                    .foregroundColor(emu.color)
                    .font(Font.caption2.monospacedDigit())
            }
        }
    }
}




@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetSingleColumnEntryView(entry: entry)
        }
        .configurationDisplayName("收藏列车交路信息")
        .description("此处展示收藏的列车或车组的实时交路信息。")
        .supportedFamilies([.systemSmall])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSingleColumnEntryView(entry: FavoritesEntry(date: Date(), favoriteTrains: [EMU(emu: "CRH2C2001", train: "D0001", date: "20210102"), EMU(emu: "CR400AF0001", train: "G1", date: "20210102"), EMU(emu: "CR300BFB0001", train: "G1", date: "20210102"),EMU(emu: "CRH2C2001", train: "D0001", date: "20210102"), EMU(emu: "CR400AF0001", train: "G1", date: "20210102"), EMU(emu: "CR300BFB0001", train: "G1", date: "20210102"),], favoriteEmus: [EMU(emu: "CR400AFB0001", train: "G1", date: "20210102")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
