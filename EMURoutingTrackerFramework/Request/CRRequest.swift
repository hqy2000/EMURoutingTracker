//
//  CRRequest.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
enum CRRequest {
    case train(trainNo: String, date: String)
    case stations
    case leftTicketPrice(from: String, to: String, date: String)
}

extension CRRequest: APIRequest {
    var baseURL: URL {
        switch self {
        case .train(_, _):
            return URL(string: "https://search.12306.cn")!
        default:
            return URL(string: "https://kyfw.12306.cn/")!
        }
    }
    
    var path: String {
        switch self {
        case .train(_,_):
            return "search/v1/train/search"
        case .stations:
            return "otn/resources/js/framework/station_name.js"
        case .leftTicketPrice(_, _, _):
            return "otn/leftTicketPrice/queryAllPublicPrice"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .train(let trainNo, let date):
            return [
                URLQueryItem(name: "keyword", value: trainNo),
                URLQueryItem(name: "date", value: date)
            ]
        case .stations:
            return nil
        case .leftTicketPrice(let from, let to, let date):
            return [
                URLQueryItem(name: "leftTicketDTO.train_date", value: date),
                URLQueryItem(name: "leftTicketDTO.from_station", value: from),
                URLQueryItem(name: "leftTicketDTO.to_station", value: to),
                URLQueryItem(name: "leftTicketDTO.ticket_type", value: "1"),
                URLQueryItem(name: "randCode", value: "")
            ]
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var headers: [String : String]? {
        return ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"]
    }
}
