//
//  MoerailProvider.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/11/20.
//

import Foundation
import Cache
import Sentry

internal class TimetableProvider: AbstractProvider<CRRequest> {
    public static let shared = TimetableProvider()
    private let storage: Storage<String, [Timetable]>
    private var queue: [(String, String, ([Timetable]) -> Void)] = []
    private var lock: Bool = false
    
    override private init() {
        let diskConfig = DiskConfig(name: "Timetables")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)

        self.storage = try! Storage(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [Timetable].self)
        )
        
        super.init()
    }

    internal func get(forTrain train: String, onDate date: String, completion: @escaping ([Timetable]) -> Void) {
        do {
            completion(try storage.object(forKey: train + date))
        } catch {
            self.queue.append((train, date, completion))
            self.run()
        }
    }
    
    private func run() {
        if !lock && queue.count > 0{
            lock = true
            self.execute(train: queue.first!.0, date: queue.first!.1, completion: queue.first!.2)
            self.queue.removeFirst()
        }
    }
    
    public func cancelAll() {
        self.queue = []
    }
    
    private func execute(train: String, date: String, completion: @escaping ([Timetable]) -> Void) {
        debugPrint("[Timetabke Queue] \(train) @ \(date)")
        debugPrint("[Timetable Queue] Remain count: \(self.queue.count).")
        if let timetable = try? storage.object(forKey: train + date) {
            completion(timetable)
        } else {
            self.request(target: .train(trainNo: train, date: date), type: CRResponse<CRDataWrapper<[Timetable]>>.self) { (timetable) in
                try? self.storage.setObject(timetable.data.data, forKey: train + date)
                completion(timetable.data.data)
                
                self.lock = false
                self.run()
            } failure: { error in
                debugPrint("Error with: \(train).")
                self.lock = false
                self.run()
            }
        }
        
    }
}
