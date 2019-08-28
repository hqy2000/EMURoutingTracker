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
    
    func getTrackingRecord(keyword: String, completion: @escaping () -> Void) {
        
        if (keyword.starts(with: "C") && !keyword.starts(with: "CR")) || keyword.starts(with: "G") || keyword.starts(with: "D") {
            self.requestStatic(target: .train(keyword: keyword), type: ListWrapper<TrainModel>.self, success: { results in
                self.list = results.data
                completion()
            })
        } else {
            self.requestStatic(target: .emu(keyword: keyword), type: ListWrapper<TrainModel>.self, success: { results in
                self.list = results.data
                completion()
            })
        }
    }
}
