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
    public func getTrainList() {
        let provider = MoyaProvider<MoeRailRequest>(plugins: [NetworkLoggerPlugin(verbose: true)])
        provider.request(.models) { result in
            switch result {
            case let .success(data):
                print("yes")
                print(provider.manager.session.configuration.httpAdditionalHeaders)
                print(data.response)
            case let .failure(error):
                print("no")
                print(error)
                break
                
            }
        }
    }
    
    public func getStations(completion: @escaping (StationList) -> ()) {
        let provider = MoyaProvider<MoeRailRequest>()
        provider.request(.stations) { result in
            switch result {
            case let .success(data):
                do {
                    let json = try JSON(data: data.data)
                    completion(StationList(json))
                } catch {
                
                }
                
            case let .failure(error):
                print("no")
            }
        }
    }
    
    public func getTrainDiagram(forTrain train: String) {
        
    }
}
