//
//  CRRequest.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import Moya

@frozen
enum CRRequest {
    case train(trainNo: String, date: String)
}

extension CRRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://www.12306.cn/")!
    }
    
    var path: String {
        switch self {
        case .train(_,_):
            return "kfzmpt/queryTrainInfo/query/"
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
        }
    }
    
    var headers: [String : String]? {
        return ["User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"]
    }
    
    
}
