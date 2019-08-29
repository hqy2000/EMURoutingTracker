//
//  Version.swift
//  ios
//
//  Created by hqy2000 on 8/30/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class Version: ImmutableMappable {
    required init(map: Map) throws {
        self.stationDatabase = try map.value("station_database")
        self.trainDatabase = try map.value("train_database")
        self.latest = try map.value("latest_ios")
    }
    
    let stationDatabase: String
    let trainDatabase: String
    let latest: String
}
