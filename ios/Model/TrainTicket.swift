//
//  TrainTicket.swift
//  ios
//
//  Created by hqy2000 on 7/13/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class TrainTicket: ImmutableMappable, Codable {
    let trainNo: String
    let trainNumber: String
    let startStationTelecode: String
    let startStationName: String
    let endStationTelecode: String
    let endStationName: String
    let fromStationName: String
    let fromStationTelecode: String
    let toStationTelecode: String
    let toStationName: String
    let startTime: String
    let arriveTime: String
    let dayDifference: String
    let duration: String

    let trainSeatFeature: String
    let softSleeper: String // 软卧 rw
    let softSeat: String // 软座 rz
    let stateClassCoach: String // 特等座 tz
    let noSeat: String // 无座 wz
    let hardSleeper: String // 硬卧 yw
    let hardSeat: String // 硬座 yz
    let firstClassCoach: String // 一等座 zy
    let secondClassCoach: String // 二等座 ze
    let businessClassCoach: String // 商务座 swz
    let emuSleeper: String // 动卧 srrb
    
    required init(map: Map) throws {
        self.trainNo = try map.value("train_no")
        self.trainNumber = try map.value("station_train_code")
        
        self.startStationTelecode = try map.value("start_station_telecode")
        self.startStationName = try map.value("start_station_name")
        self.endStationTelecode = try map.value("end_station_telecode")
        self.endStationName = try map.value("end_station_name")
        self.fromStationTelecode = try map.value("from_station_telecode")
        self.fromStationName = try map.value("from_station_name")
        self.toStationTelecode = try map.value("to_station_telecode")
        self.toStationName = try map.value("to_station_name")
        
        self.startTime = try map.value("start_time")
        self.arriveTime = try map.value("arrive_time")
        self.dayDifference = try map.value("day_difference")
        self.duration = try map.value("lishi")
        
        self.trainSeatFeature = try map.value("train_seat_feature")
        self.softSleeper = try map.value("rw_num")
        self.softSeat = try map.value("rz_num")
        self.stateClassCoach = try map.value("tz_num")
        self.noSeat = try map.value("wz_num")
        self.hardSleeper = try map.value("yw_num")
        self.hardSeat = try map.value("yz_num")
        self.firstClassCoach = try map.value("zy_num")
        self.secondClassCoach = try map.value("ze_num")
        self.businessClassCoach = try map.value("swz_num")
        self.emuSleeper = try map.value("srrb_num")
    }
    
    public func getAvailableSeating() -> [String] {
        var available: [String] = []
        if self.businessClassCoach != "--" {
            available.append("商务座：\(self.businessClassCoach)")
        }
        if self.stateClassCoach != "--" {
            available.append("特等座：\(self.stateClassCoach)")
        }
        if self.firstClassCoach != "--" {
            available.append("一等座：\(self.firstClassCoach)")
        }
        if self.secondClassCoach != "--" {
            available.append("二等座：\(self.secondClassCoach)")
        }
        if self.hardSeat != "--" {
            available.append("硬座：\(self.hardSeat)")
        }
        if self.softSeat != "--" {
            available.append("软座：\(self.softSeat)")
        }
        if self.hardSleeper != "--" {
            available.append("硬卧：\(self.hardSleeper)")
        }
        if self.softSleeper != "--" {
            available.append("软卧：\(self.softSleeper)")
        }
        if self.noSeat != "--" {
            available.append("无座：\(self.noSeat)")
        }
        if self.emuSleeper != "--" {
            available.append("动卧：\(self.noSeat)")
        }
        return available
    }
}
