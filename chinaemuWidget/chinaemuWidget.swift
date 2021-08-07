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

struct Provider: IntentTimelineProvider {
    let favoriteData = FavoritesData()
    func placeholder(in context: Context) -> FavoritesEntry {
        favoriteData.refresh()
        let entry = FavoritesEntry(date: Date(), favoriteTrains: [], favoriteEmus: [])
        return entry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (FavoritesEntry) -> ()) {
        favoriteData.refresh {
            print("snapshot")
            dump(favoriteData.$favoriteTrains)
            let entry = FavoritesEntry(date: Date(), favoriteTrains: favoriteData.favoriteTrains, favoriteEmus: favoriteData.favoriteEMUs)
            completion(entry)
        }
       
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        favoriteData.refresh {
            print("snapshot")
            dump(favoriteData.$favoriteTrains)
            let entry = FavoritesEntry(date: Date(), favoriteTrains: favoriteData.favoriteTrains, favoriteEmus: favoriteData.favoriteEMUs)
            let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 15, to: Date())!

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

struct widgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        List {
            ForEach(entry.favoriteTrains, id: \.self) { emu in
                GeneralView(emu)
            }
            ForEach(entry.favoriteEmus, id: \.self) { emu in
                GeneralView(emu)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct GeneralView: View {
    let emu: EMU
    
    init(_ emu: EMU) {
        self.emu = emu
    }
    
    var body: some View {
        HStack {
            Image(emu.image)
            Text(emu.emu)
                .font(Font.body.monospacedDigit())
    
            Spacer()
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    Text(emu.train)
                        .font(Font.callout)
                }
                HStack {
                    Spacer()
                    Text("\(emu.timetable.first?.station ?? "") ⇀ \(emu.timetable.last?.station ?? "")").font(Font.caption2)
                }
            }
        }
    }
}


@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("收藏列车交路信息")
        .description("此处展示收藏的列车或车组的实时交路信息。")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: FavoritesEntry(date: Date(), favoriteTrains: [], favoriteEmus: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
