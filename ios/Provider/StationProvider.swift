//
//  StationProvider.swift
//  ios
//
//  Created by hqy2000 on 7/13/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Cache

internal final class StationProvider {
    private let storage: Storage<[Station]>
    internal var stations: [Station] = []
    private let onDataRefresh: (String?) -> ()
    
    internal init(_ completion: @escaping (String?) -> ()) {
        guard let hybridStorage = try? HybridStorage(memoryStorage: MemoryStorage(config: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)), diskStorage: DiskStorage(config: DiskConfig(name: "Station"), transformer: TransformerFactory.forCodable(ofType: [Station].self))) else { fatalError() }
        let storage: Storage<[Station]> = Storage(hybridStorage: hybridStorage)
        self.storage = storage
        self.onDataRefresh = completion
        self.fetchStations()
    }
    
    internal func fetchStations() {
        if stations.count == 0 {
            let provider = MoyaProvider<MoeRailRequest>()
            provider.request(.stations) { result in
                switch result {
                case let .success(data):
                    do {
                        let json = try JSON(data: data.data)
                        if let raw = json.array {
                            let stations: [Station] = raw.map({Station($0)})
                            try self.storage.setObject(stations, forKey: "stations")
                            self.stations = stations
                            self.onDataRefresh(nil)
                        }
                    } catch {
                        self.onDataRefresh("数据错误")
                    }
                    
                case let .failure(error):
                    self.onDataRefresh(error.errorDescription)
                }
            }
        } else {
            if let stations = try? self.storage.object(forKey: "stations") {
                self.stations = stations
                self.onDataRefresh(nil)
            }
        }
    }
    
    internal func search(for keyword: String) -> [Station] {
        return self.stations.filter({$0.pinyin_short.starts(with: keyword.lowercased()) || $0.pinyin_full.starts(with: keyword.lowercased())})
    }
}
