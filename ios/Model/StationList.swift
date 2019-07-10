//
//  StationList.swift
//  ios
//
//  Created by hqy2000 on 7/9/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

class StationList {
    init(_ json: JSON) {
        self.list = []
        for (_, item) in json {
            self.list.append(Station(item))
        }
    }
    struct Station {
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
    
    var list: [Station]
}
