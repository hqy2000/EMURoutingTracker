//
//  MoerailProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import JavaScriptCore
import Sentry
import SwiftUI

@MainActor
internal class StationProvider: ObservableObject {
    public static let shared = StationProvider()
    private let provider = AbstractProvider<CRRequest>()
    @Published public private(set) var stations: [Station] = []
    
    private init() {
        Task { [weak self] in
            await self?.fetchStations()
        }
    }
    
    private func fetchStations() async {
        do {
            let result = try await provider.requestRaw(target: .stations)
            let context = JSContext()
            context?.evaluateScript(result)
            if let raw = context?.objectForKeyedSubscript("station_names")?.toString() {
                let stations: [Station] = raw.split(separator: "@").map { rawStation in
                    let info = rawStation.split(separator: "|")
                    guard info.count >= 5 else {
                        return Station(name: "", code: "", pinyin: "", abbreviation: "")
                    }
                    return Station(
                        name: String(info[1]),
                        code: String(info[2]),
                        pinyin: String(info[3]),
                        abbreviation: String(info[4])
                    )
                }
                self.stations = stations
            } else {
                SentrySDK.capture(message: "Error decoding stations: \(result)")
            }
        } catch {
            SentrySDK.capture(message: "Error fetching stations: \(error.localizedDescription)")
        }
    }
}
