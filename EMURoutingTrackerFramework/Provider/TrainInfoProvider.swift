//
//  MoerailProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import Sentry

internal class TrainInfoProvider: AbstractProvider<CRRequest> {
    public static let shared = TrainInfoProvider()
    private let storage: Storage<String, Train>
    private var queue: [(String, (Train) -> Void)] = []
    private var lock: Bool = false
    
    override private init() {
        let diskConfig = DiskConfig(name: "TrainInfo")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)

        self.storage = try! Storage(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          fileManager: FileManager.default,
          transformer: TransformerFactory.forCodable(ofType: Train.self)
        )
        
        super.init()
    }

    internal func get(forTrain train: String, completion: @escaping (Train) -> Void) {
        do {
            completion(try storage.object(forKey: train))
        } catch {
            SentrySDK.capture(error: error)
            self.queue.append((train, completion))
            self.run()
        }
    }
    
    private func run() {
        DispatchQueue.global().sync {
            if !lock && queue.count > 0{
                lock = true
                let top = self.queue.removeFirst()
                self.execute(train: top.0, completion: top.1)
                
            }
        }
    }
    
    public func cancelAll() {
        DispatchQueue.global().sync {
            self.queue = []
        }
    }
    
    private func execute(train: String, completion: @escaping (Train) -> Void) {
        if let timetable = try? storage.object(forKey: train) {
            completion(timetable)
            DispatchQueue.global().sync {
                self.lock = false
                self.run()
            }
        } else {
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd"
            
            self.request(target: .train(trainNo: train, date: df.string(from: Date())), type: CRResponse<[Train]>.self) { (info) in
                for entry in info.data {
                    if entry.station_train_code == train {
                        try? self.storage.setObject(entry, forKey: train, expiry: .date(Date().addingTimeInterval(60 * 60 * 24 * 2)))
                        completion(entry)
                        DispatchQueue.global().sync {
                            self.lock = false
                            self.run()
                        }
                        
                        return
                    }
                }
                
                debugPrint("Unable to find: \(train).")
                let entry = Train(from: "未知", to: "未知", train_no: "", date: "", station_train_code: "")
                try? self.storage.setObject(entry, forKey: train, expiry: .date(Date().addingTimeInterval(20)))
                completion(entry)
                
                DispatchQueue.global().sync {
                    self.lock = false
                    self.run()
                }

            } failure: { error in
                debugPrint("Error with: \(train).")
                DispatchQueue.global().sync {
                    self.lock = false
                    self.run()
                }
            }
        }
        
    }
}
