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
    case leftTicket(from: String, to: String, date: String)
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
        case .leftTicket(_, _, _):
            return "kfzmpt/lcxxcx/query"
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
        case .leftTicket(let from, let to, let date):
            return .requestParameters(parameters: [
                "1queryDate": date,
                "2from_station": from,
                "3to_station": to,
                "0purpose_codes": "ADULT"
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