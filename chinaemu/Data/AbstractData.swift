//
//  AbstractData.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

class AbstractData<T: TargetType> {
    let provider = MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    
    internal func request<R: Codable> (target: T, type: R.Type, success: @escaping (R) -> Void, failure: ((Error) -> Void)? = nil) {
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                do {
                    if (response.statusCode == 200) {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(R.self, from: response.data)
                            success(result)
                        } catch {
                            debugPrint(error.localizedDescription)
                            failure?(error)
                        }

                    } else {
                        debugPrint("Request failed \(response.statusCode).")
                    }
                } catch let error {
                    debugPrint(error)
                    failure?(error)
                }
                break
            case let .failure(error):
                debugPrint(error)
                failure?(error)
            }
        }
    }
}

