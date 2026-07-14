//
//  NetworkService.swift
//  AccountBook
//
//  Created by 이정원 on 7/14/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

import Foundation

struct NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let urlRequest = try endpoint.urlRequest
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        try checkResponse(response)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func download(_ endpoint: Endpoint) async throws -> URL {
        let urlRequest = try endpoint.urlRequest
        let (url, response) = try await URLSession.shared.download(for: urlRequest)
        
        try checkResponse(response)
        return url
    }
}

private extension NetworkService {
    func checkResponse(_ response: URLResponse) throws {
        let httpResponse = response as? HTTPURLResponse
        guard let httpResponse else { throw NetworkError.noResponse }
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
        case 200...299: return
        default: throw NetworkError(statusCode)
        }
    }
}
