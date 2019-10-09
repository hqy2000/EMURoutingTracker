//
//  RequestError.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation

struct RequestError: LocalizedError {
    var errorDescription: String? {
        return message
    }
    
    var failureReason: String? {
        return message
    }
    
    var code: Int
    
    private var message: String

    public init(message: String, code: Int) {
        self.message = message
        self.code = code
    }
}
