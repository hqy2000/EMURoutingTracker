//
//  TrainTicket.swift
//  ios
//
//  Created by hqy2000 on 7/13/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class TrainTicket: Codable {
    let trainId: String
    let trainNumber: String
    let origin: String
    let terminal: String
    let from: String
    let to: String
    let fromIndex: String
    let toIndex: String
    let start: String
    let end: String
    let duration: String
    let isSelling: Bool
    let stateClassCoach: String
    let businessClassCoach: String
    let firstClassCoach: String
    let secondClassCoach: String
    let deluxeSoftSleeper: String
    let softSleeper: String
    let highSpeedSleeper: String
    let hardSleeper: String
    let softSeat: String
    let hardSeat: String
    let noSeat: String
    
    init(_ str: String) {
        let details = str.components(separatedBy: "|")
        self.trainId = details[0]
        self.trainNumber = details[1]
        self.origin = details[2]
        self.terminal = details[3]
        self.from = details[4]
        self.fromIndex = details[5]
        self.to = details[6]
        self.toIndex = details[7]
        self.start = details[8]
        self.end = details[9]
        self.duration = details[10]
        self.isSelling = details[11] == "Y"
        self.stateClassCoach = details[12]
        self.businessClassCoach = details[13]
        self.firstClassCoach = details[14]
        self.secondClassCoach = details[15]
        self.deluxeSoftSleeper = details[16]
        self.softSleeper = details[17]
        self.highSpeedSleeper = details[18]
        self.hardSleeper = details[19]
        self.softSeat = details[20]
        self.hardSeat = details[21]
        self.noSeat = details[22]
    }
    
    public func getAvailableSeating() -> [String] {
        var available: [String] = []
        if self.businessClassCoach != "" {
            available.append("商务座：\(self.businessClassCoach)")
        }
        if self.stateClassCoach != "" {
            available.append("特等座：\(self.stateClassCoach)")
        }
        if self.firstClassCoach != "" {
            available.append("一等座：\(self.firstClassCoach)")
        }
        if self.secondClassCoach != "" {
            available.append("二等座：\(self.secondClassCoach)")
        }
        if self.hardSeat != "" {
            available.append("硬座：\(self.hardSeat)")
        }
        if self.softSeat != "" {
            available.append("软座：\(self.softSeat)")
        }
        if self.hardSleeper != "" {
            available.append("硬卧：\(self.hardSleeper)")
        }
        if self.softSleeper != "" {
            available.append("软卧：\(self.softSleeper)")
        }
        if self.deluxeSoftSleeper != "" {
            available.append("高级软卧：\(self.deluxeSoftSleeper)")
        }
        if self.noSeat != "" {
            available.append("无座：\(self.noSeat)")
        }
        return available
    }
}

class TrainTicketsWrapper: ImmutableMappable {
    required init(map: Map) throws {
        let details: [String] = try map.value("data")
        self.data = details.map({TrainTicket($0)})
    }
    let data: [TrainTicket]
}
