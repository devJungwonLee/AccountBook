//
//  UserDefaults+.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/05.
//

import Foundation

extension UserDefaults {
    func value<T: Decodable>(forKey: String, _ type: T.Type) -> T? {
        guard let data = object(forKey: forKey) as? Data,
              let value = try? JSONDecoder().decode(type.self, from: data) else {
            return nil
        }
        return value
    }
    
    func setValue<T: Encodable>(forKey: String, _ value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        setValue(data, forKey: forKey)
    }
}
