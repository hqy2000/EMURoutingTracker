//
//  MoerailRequest.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import Moya

@frozen
enum MoerailRequest {
    case train(keyword: String)
    case trains(keywords: [String])
    case emu(keyword: String)
}

extension MoerailRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.moerail.ml/")!
    }
    
    var path: String {
        switch self {
        case .train(let keyword):
            return "train/" + keyword
        case .trains(let keywords):
            return "train/" + keywords.reduce("", { prev, current in
                return prev + "," + current
            })
        case .emu(let keyword):
            return "emu/\(keyword)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
