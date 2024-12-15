//
//  CRRequest.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import Moya
import Alamofire

enum CRRequest {
    case train(trainNo: String, date: String)
    case stations
    case leftTicketPrice(from: String, to: String, date: String)
}

extension CRRequest: TargetType {
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
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .train(let trainNo, let date):
            return .requestParameters(parameters: [
                "keyword": trainNo,
                "date": date
            ], encoding: URLEncoding.default)
        case .stations:
            return .requestPlain
        case .leftTicketPrice(let from, let to, let date):
            return .requestParameters(parameters: [
                "leftTicketDTO.train_date": date,
                "leftTicketDTO.from_station": from,
                "leftTicketDTO.to_station": to,
                "leftTicketDTO.ticket_type": 1,
                "randCode": ""
            ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"]
    }
}
