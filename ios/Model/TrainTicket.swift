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
    let trainNumber: String
    let from: String
    let to: String
    let origin: String
    let terminal: String
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
        self.trainNumber = details[0]
        self.from = details[1]
        self.to = details[2]
        self.origin = details[3]
        self.terminal = details[4]
        self.start = details[5]
        self.end = details[6]
        self.duration = details[7]
        self.isSelling = details[8] == "Y"
        self.stateClassCoach = details[9]
        self.businessClassCoach = details[10]
        self.firstClassCoach = details[11]
        self.secondClassCoach = details[12]
        self.deluxeSoftSleeper = details[13]
        self.softSleeper = details[14]
        self.highSpeedSleeper = details[15]
        self.hardSleeper = details[16]
        self.softSeat = details[17]
        self.hardSeat = details[18]
        self.noSeat = details[19]
    }
}

