//
//  TrainSchedule.swift
//  ios
//
//  Created by hqy2000 on 7/16/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class TrainSchedule: ImmutableMappable {
    required init(map: Map) throws {
        self.arrive_day_str = try map.value("arrive_day_str")
        self.arrive_time = try map.value("arrive_time")
        self.start_time = try map.value("start_time")
        self.running_time = try map.value("running_time")
        self.station_name = try map.value("station_name")
        self.station_no = try map.value("station_no")
        self.station_train_code = try map.value("station_train_code")
    }
    
    let arrive_day_str: String
    let arrive_time: String
    let running_time: String
    let start_time: String
    let station_name: String
    let station_no: String
    let station_train_code: String
}
