//
//  widget.swift
//  widget
//
//  Created by Qingyang Hu on 11/22/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> FavoritesEntry {
        FavoritesEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    private func getEntry() {
        var entry = FavoritesEntry()
        
        if FavoritesProvider.favoriteTrains.isEmpty {
            entry.favoriteTrains = FavoritesProvider.shared.favoriteTrains.map({ (favorite) in
                return EMU(emu: "", train: favorite.name, date: "")
            })
        }
        
        if FavoritesProvider.favoriteEMUs.isEmpty {
            entry.favoriteEMUs = FavoritesProvider.shared.favoriteEMUs.map({ (favorite) in
                return EMU(emu: favorite.name, train: "", date: "")
            })
        }
        
        moerailProvider.request(target: .trains(keywords: FavoritesProvider.shared.favoriteTrains.map({ favorite in
            return favorite.name
        })), type: [EMU].self) { (result) in
            self.favoriteTrains = result
            for (index, emu) in result.enumerated() {
                TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                    self.favoriteTrains[index].timetable = timetable
                }
            }
        } failure: { (error) in
            print(error)
        }
        
        moerailProvider.request(target: .emus(keywords: FavoritesProvider.shared.favoriteEMUs.map({ favorite in
            return favorite.name
        })), type: [EMU].self) { (result) in
            self.favoriteEMUs = result
            for (index, emu) in result.enumerated() {
                TimetableProvider.shared.get(forTrain: emu.singleTrain, onDate: emu.date) { (timetable) in
                    self.favoriteEMUs[index].timetable = timetable
                }
            }
        } failure: { (error) in
            print(error)
        }
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (FavoritesEntry) -> ()) {
        
        let entry = FavoritesEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [FavoritesEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = FavoritesEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FavoritesEntry: TimelineEntry {
    let favoriteEMUs: [EMU]
    let favoriteTrains: [EMU]
    let configuration: ConfigurationIntent
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: FavoritesEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
