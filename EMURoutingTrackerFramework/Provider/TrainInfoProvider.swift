//
//  MoerailProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import Sentry

actor TrainInfoProvider {
    public static let shared = TrainInfoProvider()
    private let provider = AbstractProvider<CRRequest>()
    private let storage: Storage<String, Train>
    private let dateFormatter: DateFormatter
    
    private init() {
        let diskConfig = DiskConfig(name: "TrainInfo")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)
        
        storage = try! Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            fileManager: FileManager.default,
            transformer: TransformerFactory.forCodable(ofType: Train.self)
        )
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        dateFormatter = formatter
    }
    
    internal func get(forTrain train: String) async throws -> Train {
        if let cached = try? storage.object(forKey: train) {
            return cached
        }
        
        let dateString = dateFormatter.string(from: Date())
        let response = try await provider.request(target: .train(trainNo: train, date: dateString), as: CRResponse<[Train]>.self)
        if let entry = response.data.first(where: { $0.station_train_code == train }) {
            try? storage.setObject(entry, forKey: train, expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 2)))
            return entry
        } else {
            SentrySDK.capture(message: "Unable to find: \(train).")
            let entry = Train(from: "未知", to: "未知", train_no: "", date: "", station_train_code: "")
            try? storage.setObject(entry, forKey: train, expiry: .date(Date().addingTimeInterval(20)))
            return entry
        }
    }
    
    public func cancelAll() {
        // Legacy API retained for compatibility; no queued tasks to cancel with async/await.
    }
}
