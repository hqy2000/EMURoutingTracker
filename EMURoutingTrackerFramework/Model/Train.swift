//
//  TrainInfo.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation

struct Train: Codable, Hashable {
    let from: String
    let to: String
    let train_no: String
    let date: String
    let station_train_code: String
    
    enum CodingKeys: String, CodingKey {
        case from = "from_station"
        case to = "to_station"
        case train_no = "train_no"
        case date = "date"
        case station_train_code = "station_train_code"
    }
}

