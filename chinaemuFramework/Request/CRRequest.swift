//
//  CRRequest.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import Moya
import Alamofire

@frozen
enum CRRequest {
    case train(trainNo: String, date: String)
    case stations
    case leftTicketPrice(from: String, to: String, date: String)
    case station(name: String, code: String, date: String)
}

extension CRRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.12306.cn/")!
    }
    
    var path: String {
        switch self {
        case .train(_,_):
            return "kfzmpt/queryTrainInfo/query/"
        case .stations:
            return "kfzmpt/resources/js/framework/station_name.js"
        case .leftTicketPrice(_, _, _):
            return "kfzmpt/leftTicketPrice/query"
        case .station(_, _, _):
            return "kfzmpt/czxx/query"
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
                "leftTicketDTO.train_no": trainNo,
                "leftTicketDTO.train_date": date
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
        case .station(let name, let code, let date):
            return .requestParameters(parameters: [
                "0train_start_date": date,
                "1train_station_name": name,
                "2train_station_code": code,
                "3randCode": ""
            ], encoding: CRURLEncoding())
        }
        
    }
    
    var headers: [String : String]? {
        return ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"]
    }
}


// 用法：在Key之前加上数字表示顺序。
struct CRURLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest!
        var urlString = urlRequest.url!.absoluteString
        
        if let parameters = parameters {
            urlString += "?"
            Array(parameters.keys.sorted()).forEach { (key) in
                urlString += String(key.suffix(key.count - 1)) + "=" + (parameters[key] as! String) + "&"
            }
            urlString = String(urlString.prefix(urlString.count - 1))
        }
        urlRequest.url = URL(string: urlString)!
        return urlRequest
    }
}
