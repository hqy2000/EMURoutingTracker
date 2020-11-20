//
//  LeftTicket.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation

struct LeftTicket: Codable {
    let departureTime: String
    let departureStation: String
    let arrivalTime: String
    let arrivalStation: String
    let trainNo: String
    
    enum CodingKeys: String, CodingKey {
        case departureTime = "start_time"
        case departureStation = "from_station_name"
        case arrivalTime = "arrive_time"
        case arrivalStation = "to_station_name"
        case trainNo = "station_train_code"
    }
}
