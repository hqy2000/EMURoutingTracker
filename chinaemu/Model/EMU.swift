//
//  Train.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation

struct EMU: Codable, Hashable, Identifiable {
    var id: Int {
        return (emu + train + date + (timetable.first?.station ?? "")).hash
    }
    
    let emu: String
    let train: String
    var singleTrain: String {
        return  String(train.prefix(train.firstIndex(of: "/")?.encodedOffset ?? train.count))
    }
    let date: String
    var timetable: [Timetable] = []
    
    var image: String {
        var filename = ""
        switch emu {
        case _ where emu.starts(with: "CR400A"):
            return "CR400A"
        case _ where emu.starts(with: "CR400B"):
            return "CR400B"
        case _ where emu.starts(with: "CR200J"):
            return "CR200J"
        case _ where emu.starts(with: "CRH1E"):
            return "CRH1E"
        case _ where emu.starts(with: "CRH1"):
            filename = "CRH1"
        case _ where emu.starts(with: "CRH2B"):
            filename = "CRH2B"
        case _ where emu.starts(with: "CRH2C"):
            filename = "CRH2C"
        case _ where emu.starts(with: "CRH2G"),
             _ where emu.starts(with: "CRH2H"):
            filename = "CRH2G"
        case _ where emu.starts(with: "CRH2"):
            filename = "CRH2"
        case _ where emu.starts(with: "CRH380B"):
            filename = "CRH380B"
        case _ where emu.starts(with: "CRH380C"):
            filename = "CRH380C"
        case _ where emu.starts(with: "CRH380D"):
            filename = "CRH380D"
        case _ where emu.starts(with: "CRH380"):
            filename = "CRH380"
        case _ where emu.starts(with: "CRH3A"):
            filename = "CRH3A"
        case _ where emu.starts(with: "CRH3"):
            filename = "CRH3"
        case _ where emu.starts(with: "CRH5"):
            filename = "CRH5"
        case _ where emu.starts(with: "CRH6F"):
            filename = "CRH6F"
        case _ where emu.starts(with: "CRH6"):
            filename = "CRH6"
        case _ where emu.starts(with: "MTR"):
            filename = "MTR"
        default:
            filename = "CRH2"
        }
        return filename
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
