//
//  NetworkError.swift
//  AccountBook
//
//  Created by 이정원 on 7/14/26.
//  Copyright © 2026 jungwon. All rights reserved.
//

enum NetworkError: Error {
    case invalidURL
    case bodyEncoding
    case disconnected
    case noResponse
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case client
    case server
    case noInternet
    case timeout
    case others
    case responseDecoding
    case unknown
    
    init(_ statusCode: Int) {
        self = switch statusCode {
        case 400: .badRequest
        case 401: .unauthorized
        case 403: .forbidden
        case 404: .notFound
        case 400...499: .client
        case 500...599: .server
        default: .others
        }
    }
}
