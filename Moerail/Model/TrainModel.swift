//
//  TrainModel.swift
//  ios
//
//  Created by hqy2000 on 8/28/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class TrainModel: ImmutableMappable {
    required init(map: Map) throws {
        self.emu = try map.value("emu_no")
        self.train = try map.value("train_no")
        self.date = try map.value("date")
    }
    
    let emu: String
    let train: String
    let date: String
}
