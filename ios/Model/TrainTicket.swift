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
}

class TrainTicketsWrapper: ImmutableMappable {
    required init(map: Map) throws {
        let details: [String] = try map.value("data")
        self.data = details.map({TrainTicket($0)})
    }
    let data: [TrainTicket]
}
