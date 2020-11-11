//
//  Train.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation

struct EMU: Codable, Identifiable {
    var id: Int {
        return (emu + train + date).hash
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
            filename = "cn-cr400a"
        case _ where emu.starts(with: "CR400B"):
            filename = "cn-cr400b"
        case _ where emu.starts(with: "CR200J"):
            filename = "cn-cr200j"
        case _ where emu.starts(with: "CRH1E"):
            filename = "cn-crh1e"
        case _ where emu.starts(with: "CRH1"):
            filename = "cn-crh1"
        case _ where emu.starts(with: "CRH2B"):
            filename = "cn-crh2b"
        case _ where emu.starts(with: "CRH2C"):
            filename = "cn-crh2c"
        case _ where emu.starts(with: "CRH2G"),
             _ where emu.starts(with: "CRH2H"):
            filename = "cn-crh2g"
        case _ where emu.starts(with: "CRH2"):
            filename = "cn-crh2"
        case _ where emu.starts(with: "CRH380B"):
            filename = "cn-crh380b"
        case _ where emu.starts(with: "CRH380C"):
            filename = "cn-crh380c"
        case _ where emu.starts(with: "CRH380D"):
            filename = "cn-crh380d"
        case _ where emu.starts(with: "CRH380"):
            filename = "cn-crh380"
        case _ where emu.starts(with: "CRH3A"):
            filename = "cn-crh3a"
        case _ where emu.starts(with: "CRH3"):
            filename = "cn-crh3"
        case _ where emu.starts(with: "CRH5"):
            filename = "cn-crh5"
        case _ where emu.starts(with: "CRH6F"):
            filename = "cn-crh6f"
        case _ where emu.starts(with: "CRH6"):
            filename = "cn-crh6"
        case _ where emu.starts(with: "MTR"):
            filename = "hk-mtr380a"
        default:
            filename = "cn-hxn5"
        }
        return filename
    }
    
    
    enum CodingKeys: String, CodingKey {
        case emu = "emu_no"
        case train = "train_no"
        case date = "date"
    }
}
