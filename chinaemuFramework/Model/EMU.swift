//
//  Train.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import SwiftUI

struct EMU: Codable, Hashable, Identifiable {
    var id: Int {
        return (emu + train + date + (trainInfo?.from ?? "")).hash
    }
    
    let emu: String
    let train: String
    var singleTrain: String {
        return  String(train.prefix(train.firstIndex(of: "/")?.encodedOffset ?? train.count))
    }
    let date: String
    var trainInfo: TrainInfo? = nil
    
    var image: String {
        var filename = ""
        switch emu {
        case _ where emu.contains("CR400A"):
            return "CR400A"
        case _ where emu.contains("CR400B"):
            return "CR400B"
        case _ where emu.contains("CR300A"):
            return "CR300A"
        case _ where emu.contains("CR300B"):
            return "CR300B"
        case _ where emu.contains("CR200J"):
            return "CR200J"
        case _ where emu.contains("CRH1E"):
            return "CRH1E"
        case _ where emu.contains("CRH1"):
            filename = "CRH1"
        case _ where emu.contains("CRH2B"):
            filename = "CRH2B"
        case _ where emu.contains("CRH2C"):
            filename = "CRH2C"
        case _ where emu.contains("CRH2G"),
             _ where emu.contains("CRH2H"):
            filename = "CRH2G"
        case _ where emu.contains("CRH2"):
            filename = "CRH2"
        case _ where emu.contains("CRH380B"):
            filename = "CRH380B"
        case _ where emu.contains("CRH380C"):
            filename = "CRH380C"
        case _ where emu.contains("CRH380D"):
            filename = "CRH380D"
        case _ where emu.contains("CRH380"):
            filename = "CRH380"
        case _ where emu.contains("CRH3A"):
            filename = "CRH3A"
        case _ where emu.contains("CRH3"):
            filename = "CRH3"
        case _ where emu.contains("CRH5"):
            filename = "CRH5"
        case _ where emu.contains("CRH6F"):
            filename = "CRH6F"
        case _ where emu.contains("CRH6"):
            filename = "CRH6"
        case _ where emu.contains("MTR"):
            filename = "MTR"
        default:
            filename = "CRH2"
        }
        return filename
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
        return self.emu.starts(with: "CRH") ? self.emu.replacingOccurrences(of: "CRH", with: "") : self.emu.replacingOccurrences(of: "CR", with: "")
    }
    
    var shortTrain: String {
        return self.train.contains("/") ? String(self.train[..<self.train.firstIndex(of: "/")!]) : self.train
    }
    
    
    enum CodingKeys: String, CodingKey {
        case emu = "emu_no"
        case train = "train_no"
        case date = "date"
    }
    
    static func == (lhs: EMU, rhs: EMU) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
