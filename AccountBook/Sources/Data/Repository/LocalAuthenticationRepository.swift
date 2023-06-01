//
//  LocalAuthenticationRepository.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/01.
//

import Combine
import LocalAuthentication

enum LocalAuthenticationError: Error {
    case cannotEvaluate
}

final class LocalAuthenticationRepository: LocalAuthenticationRepositoryType {
    func authenticate(localizedReason: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = LAContext()
            guard context.canEvaluatePolicy(
                .deviceOwnerAuthentication, error: nil
            ) else {
                return promise(.failure(LocalAuthenticationError.cannotEvaluate))
            }
            
            context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: localizedReason
            ) { isSuccess, error in
                return promise(.success(isSuccess))
            }
        }.eraseToAnyPublisher()
    }
}
