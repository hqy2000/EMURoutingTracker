//
//  MoeRailRequest.swift
//  ios
//
//  Created by hqy2000 on 7/8/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya
import Timepiece

enum MoeRailRequest {
    case models
    case stations
    case diagram(train: String)
    case version
}

extension MoeRailRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://emu.nfls.io")!
    }
    
    var path: String {
        switch self {
        case .models:
            return "models.ios.json"
        case .stations:
            return "stations.ios.json"
        case .diagram(let train):
            return "img/" + train + ".png"
        case .version:
            return "device/version"
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
