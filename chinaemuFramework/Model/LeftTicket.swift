//
//  LeftTicket.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation

struct LeftTicketInfo: Codable, Hashable, Identifiable {
    var id: String {
        return leftTicket.id
    }
    
    let leftTicket: LeftTicket
    
    enum CodingKeys: String, CodingKey {
        case leftTicket = "queryLeftNewDTO"
    }
}

struct LeftTicket: Codable, Hashable, Identifiable {
    var id: String {
        return trainNo
    }
    
    let departureTime: String
    let departureStation: String
    let arrivalTime: String
    let arrivalStation: String
    let trainNo: String
    
    let softSeat: String
    let hardSeat: String
    let softSleeper: String
    let hardSleeper: String
    
    let specialClass: String
    let businessClass: String
    let firstClass: String
    let secondClass: String
    
    let noSeat: String
    
    var isEMU: Bool {
        return trainNo.starts(with: "G") || trainNo.starts(with: "D") || trainNo.starts(with: "C")
    }
    
    enum CodingKeys: String, CodingKey {
        case departureTime = "start_time"
        case departureStation = "from_station_name"
        case arrivalTime = "arrive_time"
        case arrivalStation = "to_station_name"
        case trainNo = "station_train_code"
        
        case softSeat = "rz_num" // 软座
        case hardSeat = "yz_num" // 硬座
        case softSleeper = "rw_num" // 软卧
        case hardSleeper = "yw_num" // 硬卧
        
        case specialClass = "tz_num"
        case businessClass = "swz_num"
        case firstClass = "zy_num" // 一等座
        case secondClass = "ze_num" // 二等座
        
        case noSeat = "wz_num" // 无座
    }
}
