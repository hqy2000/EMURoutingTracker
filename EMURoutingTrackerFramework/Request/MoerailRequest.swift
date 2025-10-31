//
//  MoerailRequest.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
enum MoerailRequest {
    case train(keyword: String)
    case trains(keywords: [String])
    case emu(keyword: String)
    case emus(keywords: [String])
    case qr(emu: String, url: String)
}

extension MoerailRequest: APIRequest {
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
    
    var method: HTTPMethod {
        switch self {
        case .qr(_, _):
            return .post
        default:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }

    var body: Data? {
        switch self {
        case .qr(_, let url):
            return try? JSONSerialization.data(withJSONObject: ["url": url])
        default:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .qr:
            return ["Content-Type": "application/json"]
        default:
            return nil
        }
    }
    
    
}
