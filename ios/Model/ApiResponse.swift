//
//  ApiResponse.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse<T: BaseMappable>: ImmutableMappable {
    required init(map: Map) throws {
        self.code = try map.value("code")
        if(String(describing: T.self).contains("Wrapper")) {
            if let data = T(JSON: map.JSON) {
                self.data = data
            } else {
                throw MapError(key: "data", currentValue: map.JSON, reason: "Failed")
            }
        } else {
            self.data = try map.value("data")
        }
    }
    let code:Int
    let data:T
}

class ListWrapper<T: ImmutableMappable>: ImmutableMappable {
    required init(map: Map) throws {
        self.data = try map.value("data")
    }
    let data: [T]
}

class DataWrapper<T>: ImmutableMappable {
    required init(map: Map) throws {
        self.value = try map.value("data")
    }
    let value: T
}
