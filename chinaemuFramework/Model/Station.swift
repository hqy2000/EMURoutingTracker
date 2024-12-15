//
//  Station.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/20/20.
//

import Foundation
import SwiftyUserDefaults

struct Station: Codable, DefaultsSerializable, Hashable {
    let name: String
    let code: String
    let pinyin: String
    let abbreviation: String
    
    init(name: String, code: String, pinyin: String, abbreviation: String) {
        self.name = name
        self.code = code
        self.pinyin = pinyin
        self.abbreviation = abbreviation
    }
}
