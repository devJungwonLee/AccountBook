//
//  Endpoint.swift
//  AccountBook
//
//  Created by 이정원 on 7/14/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import Foundation

struct APIEndpoint: Endpoint {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let headers: [String: String]?
    let queryParameters: Encodable?
    let body: Encodable?
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod,
        headers: [String : String]? = .default,
        queryParameters: Encodable? = nil,
        body: Encodable? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.body = body
    }
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: Encodable? { get }
    var body: Encodable? { get }
}

extension Endpoint {
    var queryItems: [URLQueryItem]? {
        guard let queryParameters,
              let data = try? JSONEncoder().encode(queryParameters),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let dictionary = jsonObject as? [String: String] else {
            return nil
        }
        
        return dictionary.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
    
    var httpBody: Data? {
        get throws {
            guard let body else { return nil }
            return try JSONEncoder().encode(body)
        }
    }
    
    var urlRequest: URLRequest {
        get throws {
            guard var url = URL(string: baseURL) else {
                throw NetworkError.invalidURL
            }
            
            url.append(path: path)
            if let queryItems { url.append(queryItems: queryItems) }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue.uppercased()
            urlRequest.allHTTPHeaderFields = headers

            do {
                urlRequest.httpBody = try httpBody
            } catch is EncodingError {
                throw NetworkError.bodyEncoding
            }

            urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
            return urlRequest
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

extension [String: String] {
    static let `default`: Self = [
        "Content-Type": "application/json"
    ]
}
