//
//  BackupRecoveryRepositoryType.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/13.
//

import Foundation
import Combine

protocol BackupRecoveryRepositoryType {
    func fetchBackupDate() -> AnyPublisher<Date?, Error>
    func saveBackupDate(_ date: Date) -> AnyPublisher<Void, Error>
    func fetchAccountCount() -> AnyPublisher<Int, Error>
    func deleteBackupData() -> AnyPublisher<Void, Error>
}
