//
//  12306Request.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya

enum CRRequest {
    case leftTicket(from: String, to: String, date: Date)
    case queryByTrainNo(train: String, from: String, to: String, date: Date)
    case czxx(station: String, date: Date)
    case queryByTrainNumber(train: String, date: Date)
}

extension CRRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://emu.nfls.io/12306")!
    }
    
    var path: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch self {
        case .leftTicket(let from, let to, let date):
            return .requestParameters(parameters: [
                "from": from,
                "to": to,
                "date": dateFormatter.string(from: date)
                ], encoding: URLEncoding.default)
        case .queryByTrainNo(let train, let from, let to, let date):
            return .requestParameters(parameters: [
                "train": train,
                "from": from,
                "to": to,
                "date": dateFormatter.string(from: date)
                ], encoding: URLEncoding.default)
        case .czxx(let station, let date):
            return .requestParameters(parameters: [
                "station": station,
                "date": dateFormatter.string(from: date)
                ], encoding: URLEncoding.default)
        case .queryByTrainNumber(let train, let date):
            return .requestParameters(parameters: [
                "train": train,
                "date": dateFormatter.string(from: date)
                ], encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        return nil
    }
}
