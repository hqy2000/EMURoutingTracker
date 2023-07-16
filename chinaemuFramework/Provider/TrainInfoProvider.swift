//
//  MoerailProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import Sentry

internal class TrainInfoProvider: AbstractProvider<CRRequest> {
    public static let shared = TrainInfoProvider()
    private let storage: Storage<String, TrainInfo>
    private var queue: [(String, String, (TrainInfo) -> Void)] = []
    private var lock: Bool = false
    
    override private init() {
        let diskConfig = DiskConfig(name: "TrainInfo")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)

        self.storage = try! Storage(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: TrainInfo.self)
        )
        
        super.init()
    }

    internal func get(forTrain train: String, onDate date: String, completion: @escaping (TrainInfo) -> Void) {
        do {
            completion(try storage.object(forKey: train))
        } catch {
            self.queue.append((train, date, completion))
            self.run()
        }
    }
    
    private func run() {
        DispatchQueue.global().sync {
            if !lock && queue.count > 0{
                lock = true
                let top = self.queue.removeFirst()
                self.execute(train: top.0, date: top.1, completion: top.2)
                
            }
        }
    }
    
    public func cancelAll() {
        DispatchQueue.global().sync {
            self.queue = []
        }
    }
    
    private func execute(train: String, date: String, completion: @escaping (TrainInfo) -> Void) {
        debugPrint("[Timetable Queue] \(train) @ \(date)")
        debugPrint("[Timetable Queue] Remain count: \(self.queue.count).")
        if let timetable = try? storage.object(forKey: train) {
            completion(timetable)
            DispatchQueue.global().sync {
                self.lock = false
                self.run()
            }
        } else {
            self.request(target: .train(trainNo: train, date: date.components(separatedBy: " ")[0].replacingOccurrences(of: "-", with: "")), type: CRResponse<[TrainInfo]>.self) { (info) in
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
