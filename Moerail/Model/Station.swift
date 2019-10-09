//
//  StationList.swift
//  ios
//
//  Created by hqy2000 on 7/9/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SwiftyJSON

class Station: Equatable, Codable, Comparable {
    static func < (lhs: Station, rhs: Station) -> Bool {
        return lhs.pinyin_full < rhs.pinyin_full
    }
    
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.telecode == rhs.telecode
    }
    
    init(_ json: JSON) {
        self.id = Int(json[5].string ?? "0")!
        self.pinyin_code = json[0].string ?? ""
        self.name = json[1].string ?? ""
        self.telecode = json[2].string ?? ""
        self.pinyin_full = json[3].string ?? ""
        self.pinyin_short = json[4].string ?? ""
    }
    
    let id: Int
    let name: String
    let telecode: String
    let pinyin_code: String
    let pinyin_full: String
    let pinyin_short: String
}

