//
//  AbstractData.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/8/20.
//

import Foundation
import Sentry

class AbstractProvider<T: APIRequest> {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    /// Makes a request and returns the decoded response.
    func request<R: Decodable>(target: T, as type: R.Type) async throws -> R {
        let (data, _) = try await performRequest(target: target)
        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            SentrySDK.capture(error: error)
            throw error
        }
    }
    
    /// Makes a request and returns the raw response body as a string.
    func requestRaw(target: T) async throws -> String {
        let (data, _) = try await performRequest(target: target)
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    private func performRequest(target: T) async throws -> (Data, HTTPURLResponse) {
        let request = try target.makeURLRequest()
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = URLError(.badServerResponse)
            SentrySDK.capture(error: error)
            throw error
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            let error = NetworkError(
                httpResponse.statusCode,
                request.url?.absoluteString ?? "<Empty URL>",
                String(data: data, encoding: .utf8) ?? "<Empty Content>"
            )
            SentrySDK.capture(error: error)
            throw error
        }
        
        return (data, httpResponse)
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
