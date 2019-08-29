//
//  Version.swift
//  ios
//
//  Created by hqy2000 on 7/16/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let stationDatabaseVersion = DefaultsKey<String>("station_database", defaultValue: "0000-00-00")
    static let trainDatabaseVersion = DefaultsKey<String>("train_database", defaultValue: "0000-00-00")
}
