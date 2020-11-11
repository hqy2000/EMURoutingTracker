//
//  Timetable.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation

struct Timetable: Codable {
    let arrival: String
    let departure: String
    let station: String
    
    enum CodingKeys: String, CodingKey {
        case arrival = "arrive_time"
        case departure = "start_time"
        case station = "station_name"
    }
}

