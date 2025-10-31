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
    
    static func == (lhs: EMUTrainAssociation, rhs: EMUTrainAssociation) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
