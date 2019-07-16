//
//  MoeRailProvider.swift
//  ios
//
//  Created by hqy2000 on 7/8/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

class MoeRailProvider {
    let provider = MoyaProvider<MoeRailRequest>(plugins: [NetworkLoggerPlugin(verbose: true)])
    public func getTrainList() {
        
        provider.request(.models) { result in
            switch result {
            case let .success(data):
                print("yes")
                //print(provider.manager.session.configuration.httpAdditionalHeaders)
                print(data.response)
            case let .failure(error):
                print("no")
                print(error)
                break
                
            }
        }
    }
    
    public func getTrainDiagram(forTrain train: String) {
        
    }
}
