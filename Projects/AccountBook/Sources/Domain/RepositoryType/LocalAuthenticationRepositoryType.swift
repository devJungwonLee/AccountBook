//
//  LocalAuthenticationRepositoryType.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/01.
//

import Combine

protocol LocalAuthenticationRepositoryType {
    func authenticate(localizedReason: String) -> AnyPublisher<Bool, Error>
}
