//
//  MoeRailProvider.swift
//  ios
//
//  Created by hqy2000 on 7/8/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Cache
import SwiftyUserDefaults

class MoeRailProvider: AbstractProvider<MoeRailRequest> {
    private let listStorage: Storage<TrainList>
    internal var trainList: TrainList? = nil
    private let onDataRefresh: (String?) -> ()
    
    internal init(_ completion: @escaping (String?) -> ()) {
        guard let hybridStorage = try? HybridStorage(memoryStorage: MemoryStorage(config: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)), diskStorage: DiskStorage(config: DiskConfig(name: "TrainList"), transformer: TransformerFactory.forCodable(ofType: TrainList.self))) else { fatalError() }
        let listStorage: Storage<TrainList> = Storage(hybridStorage: hybridStorage)
        self.listStorage = listStorage
        self.onDataRefresh = completion
        super.init()
        self.getVersion()
        self.getTrainList()
    }
    
    internal func getVersion() {
        self.request(target: MoeRailRequest.version, type: Version.self, success: { (version) in
            Defaults[.stationDatabaseVersion] = version.stationDatabase
            Defaults[.trainDatabaseVersion] = version.trainDatabase
        })
    }
    
    internal func getTrainList() {
        if self.trainList == nil {
            if let trainList = try? self.listStorage.object(forKey: "trainList") {
                self.trainList = trainList
                self.onDataRefresh(nil)
            }
            self.requestStatic(target: .models, type: TrainList.self, success: { result in
                do {
                    try self.listStorage.setObject(result, forKey: "trainList")
                    self.trainList = result
                    self.onDataRefresh(nil)
                } catch {
                    self.onDataRefresh("数据错误")
                }
                
            })
        }
    }
    
    internal func getTrainModel(_ train: String) -> String? {
        if let trainList = self.trainList {
            return trainList.getModel(train)
        } else {
            return nil
        }
    }
}
