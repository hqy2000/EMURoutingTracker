//
//  AbstractProvider.swift
//  ios
//
//  Created by hqy2000 on 7/14/19.
//  Copyright © 2019 hqy2000. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

class AbstractProvider<T: TargetType> {
    let provider = MoyaProvider<T>()
    
    internal func request<R: BaseMappable> (target: T, type: R.Type, success: @escaping (R) -> Void, failure: ((Error) -> Void)? = nil) {
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                do {
                    let json = try JSON(data: response.data)
                    if (response.statusCode == 200) {
                        let value = try ApiResponse<R>(JSON: json.dictionaryObject!)
                        success(value.data)
                    } else {
                        let value = try ApiResponse<DataWrapper<String>>(JSON: json.dictionaryObject!)
                        let error = RequestError(message: value.data.value, code: value.code)
                        debugPrint(error)
                        failure?(error)
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
