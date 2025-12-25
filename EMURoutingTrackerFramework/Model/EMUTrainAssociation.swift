//
//  EMU.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import SwiftUI

struct EMUTrainAssociation: Codable, Hashable, Identifiable {
    var id: Int {
        return (emu + train + date + (trainInfo?.from ?? "")).hash
    }
    
    let emu: String
    let train: String
    var singleTrain: String {
        return String(train[..<(train.firstIndex(of: "/") ?? train.endIndex)])
    }
    let date: String
    var trainInfo: Train? = nil
    private(set) var parsedDate: Date? = nil
    
    var image: ImageResource {
        switch emu {
        case _ where emu.contains("CR400A"):
            return .CR_400_A
        case _ where emu.contains("CR400B"):
            return .CR_400_B
        case _ where emu.contains("CR300A"):
            return .CR_300_A
        case _ where emu.contains("CR300B"):
            return .CR_300_B
        case _ where emu.contains("CR200J"):
            return .CR_200_J
        case _ where emu.contains("CRH1E"):
            return .CRH_1_E
        case _ where emu.contains("CRH1"):
            return .CRH_1
        case _ where emu.contains("CRH2B"):
            return .CRH_2_B
        case _ where emu.contains("CRH2C"):
            return .CRH_2_C
        case _ where emu.contains("CRH2G"),
             _ where emu.contains("CRH2H"):
            return .CRH_2_H
        case _ where emu.contains("CRH2"):
            return .CRH_2
        case _ where emu.contains("CRH380B"):
            return .CRH_380_B
        case _ where emu.contains("CRH380C"):
            return .CRH_380_C
        case _ where emu.contains("CRH380D"):
            return .CRH_380_D
        case _ where emu.contains("CRH380"):
            return .CRH_380
        case _ where emu.contains("CRH3A"):
            return .CRH_3_A
        case _ where emu.contains("CRH3"):
            return .CRH_3
        case _ where emu.contains("CRH5"):
            return .CRH_5
        case _ where emu.contains("CRH6F"):
            return .CRH_6_F
        case _ where emu.contains("CRH6"):
            return .CRH_6
        case _ where emu.contains("MTR"):
            return .MTR
        default:
            return .CRH_2
        }
    }
    
    var color: Color {
        switch emu {
        case let str where str.contains("CR200"):
            return .green
        case let str where str.contains("CRH"):
            return .blue
        case let str where str.contains("CR400B") || str.contains("CR300B"):
            return .orange
        default:
            return .red
        }
    }
    
    var shortName: String {
        return emu.starts(with: "CRH") ? emu.replacingOccurrences(of: "CRH", with: "") : emu.replacingOccurrences(of: "CR", with: "")
    }
    
    var shortTrain: String {
        return train.contains("/") ? String(train[..<train.firstIndex(of: "/")!]) : train
    }
    
    
    enum CodingKeys: String, CodingKey {
        case emu = "emu_no"
        case train = "train_no"
        case date = "date"
    }
    
    init(emu: String, train: String, date: String, trainInfo: Train? = nil) {
        self.emu = emu
        self.train = train
        self.date = date
        self.trainInfo = trainInfo
        self.parsedDate = Self.parseDate(date)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let emu = try container.decode(String.self, forKey: .emu)
        let train = try container.decode(String.self, forKey: .train)
        let date = try container.decode(String.self, forKey: .date)
        self.init(emu: emu, train: train, date: date, trainInfo: nil)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(emu, forKey: .emu)
        try container.encode(train, forKey: .train)
        try container.encode(date, forKey: .date)
    }
    
    static func == (lhs: EMUTrainAssociation, rhs: EMUTrainAssociation) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension EMUTrainAssociation {
    enum Freshness {
        case fresh
        case stale
        case old
        case unknown
    }
    
    var freshness: Freshness {
        guard let dateValue = parsedDate else { return .unknown }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60) ?? .current
        let now = Date()
        if calendar.isDate(dateValue, inSameDayAs: now) {
            return .fresh
        }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.isDate(dateValue, inSameDayAs: yesterday) {
            return .stale
        }
        return .old
    }
    
    var freshnessColor: Color {
        switch freshness {
        case .fresh:
            return .green
        case .stale:
            return .yellow
        case .old:
            return .red
        case .unknown:
            return .gray
        }
    }
    
    static func parseDate(_ value: String) -> Date? {
        guard !value.isEmpty else { return nil }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
        let formats = [
            "yyyy-MM-dd HH:mm",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy/MM/dd HH:mm",
            "yyyy/MM/dd HH:mm:ss",
            "yyyy-MM-dd"
        ]
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }
        return nil
    }
}
