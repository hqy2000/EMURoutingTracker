//
//  MoerailRequest.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import Moya

enum MoerailRequest {
    case train(keyword: String)
    case trains(keywords: [String])
    case emu(keyword: String)
    case emus(keywords: [String])
    case qr(emu: String, url: String)
}

extension MoerailRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.rail.re/")!
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
        case .emus(let keywords):
            return "emu/" + keywords.reduce("", { prev, current in
                return prev + "," + current
            })
        case .qr(let emu, _):
            return "emu/\(emu)/qr"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .qr(_, _):
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .qr(_, let url):
            return .requestParameters(parameters: [
                "url": url
            ], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
