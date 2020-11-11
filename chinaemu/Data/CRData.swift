//
//  CRData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import SwiftUI
import Cache

class CRData: AbstractData<CRRequest>, ObservableObject {
    @Published var timetables = [String : [Timetable]]()
    let storage: Storage<String, [Timetable]>
    
    override init() {
        let diskConfig = DiskConfig(name: "Timetables")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 30, totalCostLimit: 50)

        self.storage = try! Storage(
          diskConfig: diskConfig,
          memoryConfig: memoryConfig,
          transformer: TransformerFactory.forCodable(ofType: [Timetable].self)
        )
        
        super.init()
    }
    
    func getTimetable(trainNo: String, date: String, completion: @escaping () -> Void) {
        do {
            self.timetables[trainNo + date] = try storage.object(forKey: trainNo + date)
            self.timetables[trainNo] = try storage.object(forKey: trainNo + date)
        } catch {
            let simpleTrainNo = String(trainNo.prefix(trainNo.firstIndex(of: "/")?.encodedOffset ?? trainNo.count))
            self.request(target: .train(trainNo: simpleTrainNo, date: date), type: CRResponse<CRDataWrapper<[Timetable]>>.self) { (timetable) in
                self.timetables[trainNo + date] = timetable.data.data
                self.timetables[trainNo] = timetable.data.data
                try? self.storage.setObject(timetable.data.data, forKey: trainNo + date)
            }
        }
    }
}
