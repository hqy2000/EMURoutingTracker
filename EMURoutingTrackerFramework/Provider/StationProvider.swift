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
import RxSwift

internal class StationProvider: AbstractProvider<CRRequest>, ObservableObject {
    public static let shared = StationProvider()
    @Published public private(set) var stations: [Station] = []
    private let disposeBag = DisposeBag()
    
    override private init() {
        super.init()
        self.get()
    }
    
    private func get() {
        self.requestRaw(target: .stations)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                let context = JSContext()
                context?.evaluateScript(result)
                if let raw = context?.objectForKeyedSubscript("station_names")?.toString() {
                    let stations: [Station] = raw.split(separator: "@").map { (raw) in
                        let info = raw.split(separator: "|")
                        if info.count < 5 {
                            return Station(name: "", code: "", pinyin: "", abbreviation: "")
                        } else {
                            return Station(name: String(info[1]), code: String(info[2]), pinyin: String(info[3]), abbreviation: String(info[4]))
                        }
                    }
                    self?.stations = stations
                } else {
                    SentrySDK.capture(message: "Error decoding stations: \(result)")
                }
            }, onFailure: { error in
                SentrySDK.capture(message: "Error fetching stations: \(error.localizedDescription)")
    
            })
            .disposed(by: disposeBag)
    }
}
