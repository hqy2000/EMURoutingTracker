//
//  CRResponse.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation

struct CRResponse<T: Codable>: Codable {
    let data: T
}

struct CRDataWrapper<T: Codable>: Codable {
    let data: T
}

struct CRDatasWrapper<T: Codable>: Codable {
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case data = "datas"
    }
}
