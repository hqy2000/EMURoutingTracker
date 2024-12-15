//
//  CRResponse.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation

struct CRResponse<T: Codable>: Codable {
    let data: T
}
