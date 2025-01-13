//
//  MoerailProvider.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import Sentry
import RxSwift

internal class TrainInfoProvider: AbstractProvider<CRRequest> {
    public static let shared = TrainInfoProvider()
    private let storage: Storage<String, Train>
    private var queue: [(String, (Train) -> Void)] = []
    private var lock: Bool = false
    private let disposeBag = DisposeBag()
    
    override private init() {
        let diskConfig = DiskConfig(name: "TrainInfo")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)
        
        storage = try! Storage(
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
            queue.append((train, completion))
            run()
        }
    }
    
    private func run() {
        DispatchQueue.global().sync {
            if !lock && queue.count > 0{
                lock = true
                let top = queue.removeFirst()
                execute(train: top.0, completion: top.1)
            }
        }
    }
    
    public func cancelAll() {
        DispatchQueue.global().sync {
            queue = []
        }
    }
    
    private func execute(train: String, completion: @escaping (Train) -> Void) {
        if let timetable = try? storage.object(forKey: train) {
            completion(timetable)
            DispatchQueue.global().sync {
                lock = false
                run()
            }
        } else {
            let df = DateFormatter()
            df.dateFormat = "yyyyMMdd"
            
            request(target: .train(trainNo: train, date: df.string(from: Date())), type: CRResponse<[Train]>.self)
                .observe(on: MainScheduler.instance)
                .subscribe(onSuccess: { info in
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
                    
                    SentrySDK.capture(message: "Unable to find: \(train).")
                    let entry = Train(from: "未知", to: "未知", train_no: "", date: "", station_train_code: "")
                    try? self.storage.setObject(entry, forKey: train, expiry: .date(Date().addingTimeInterval(20)))
                    completion(entry)
                    
                    DispatchQueue.global().sync {
                        self.lock = false
                        self.run()
                    }
                    
                }, onFailure: { error in
                    DispatchQueue.global().sync {
                        self.lock = false
                        self.run()
                    }
                })
                .disposed(by: disposeBag)
        }
        
    }
}
