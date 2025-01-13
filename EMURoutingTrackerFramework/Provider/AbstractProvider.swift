//
//  AbstractData.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import Moya
import Sentry
import RxSwift
import RxMoya

class AbstractProvider<T: TargetType> {
    let provider = MoyaProvider<T>()
    
    /// Makes a request and returns an observable of the decoded response
    func request<R: Codable>(target: T, type: R.Type) -> Single<R> {
        return provider.rx.request(target)
            .flatMap { response -> Single<R> in
                guard response.statusCode == 200 else {
                    let error = NetworkError(
                        response.statusCode,
                        response.request?.url?.absoluteString ?? "<Empty URL>",
                        String(data: response.data, encoding: .utf8) ?? "<Empty Content>"
                    )
                    SentrySDK.capture(error: error)
                    return Single.error(error)
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(R.self, from: response.data)
                    return Single.just(result)
                } catch {
                    SentrySDK.capture(error: error)
                    return Single.error(error)
                }
            }
    }
    
    /// Makes a request and returns an observable of the raw response string
    func requestRaw(target: T) -> Single<String> {
        return provider.rx.request(target)
            .flatMap { response -> Single<String> in
                guard response.statusCode == 200 else {
                    let error = NetworkError(
                        response.statusCode,
                        response.request?.url?.absoluteString ?? "<Empty URL>",
                        String(data: response.data, encoding: .utf8) ?? "<Empty Content>"
                    )
                    SentrySDK.capture(error: error)
                    return Single.error(error)
                }
                let rawString = String(data: response.data, encoding: .utf8) ?? ""
                return Single.just(rawString)
            }
    }
}

struct NetworkError: LocalizedError {
    let code: Int
    let title: String
    let content: String
    
    init(_ code: Int, _ title: String, _ content: String) {
        self.code = code
        self.title = title
        self.content = content
    }
    
    var errorDescription: String? {
        return "Error \(code): \(title)\n\(content)"
    }
}
