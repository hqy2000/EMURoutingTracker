//
//  DynamicTrackingProvider.swift
//  ios
//
//  Created by hqy2000 on 8/28/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation

class DynamicTrackingProvider: AbstractProvider<DynamicTrackingRequest> {
    var list: [TrainModel] = []
    var batch: [TrainModel] = []
    
    public func getTrackingRecord(keyword: String, completion: @escaping () -> Void) -> Bool {
        if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.requestStatic(target: .train(keyword: keyword), type: ListWrapper<TrainModel>.self, success: { results in
                self.list = results.data
                completion()
            })
            return true
        } else {
            self.requestStatic(target: .emu(keyword: keyword), type: ListWrapper<TrainModel>.self, success: { results in
                self.list = results.data
                completion()
            })
            return false
        }
    }
    
    
    public func getTrackingRecords(keywords: [String], completion: @escaping () -> Void) {
        
        self.requestStatic(target: .trains(keywords: keywords.filter({ (keyword) -> Bool in
            return keyword.starts(with: "G") || keyword.starts(with: "C") ||  keyword.starts(with: "D")
        })), type: ListWrapper<TrainModel>.self, success: { result in
            self.batch = result.data
            completion()
        })
    }

}
