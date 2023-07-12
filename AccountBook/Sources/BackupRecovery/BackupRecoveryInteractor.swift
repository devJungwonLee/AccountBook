//
//  BackupRecoveryInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs
import Foundation
import Combine
import CombineExt

protocol BackupRecoveryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BackupRecoveryPresentable: Presentable {
    var listener: BackupRecoveryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BackupRecoveryListener: AnyObject {
    func closeBackupRecovery()
    func accountsDownloaded()
}

protocol BackupRecoveryInteractorDependency {
    var accountRepository: AccountRepositoryType { get }
    var keyValueStore: NSUbiquitousKeyValueStore { get }
    var backupDateSubject: ReplaySubject<String, Never> { get }
    var accountCountSubject: ReplaySubject<String, Never> { get }
    var errorMessageSubject: PassthroughSubject<String, Never> { get }
}

final class BackupRecoveryInteractor: PresentableInteractor<BackupRecoveryPresentable>, BackupRecoveryInteractable, BackupRecoveryPresentableListener {
    weak var router: BackupRecoveryRouting?
    weak var listener: BackupRecoveryListener?
    private let dependency: BackupRecoveryInteractorDependency
    
    private var backupDate: Date {
        get { dependency.keyValueStore.object(forKey: KeyValueStoreKey.backupDate) as? Date ?? Date() }
        set(newValue) { dependency.keyValueStore.set(newValue, forKey: KeyValueStoreKey.backupDate) }
    }
    
    private var accountCount: String {
        get { dependency.keyValueStore.string(forKey: KeyValueStoreKey.accountCount) ?? "" }
        set(newValue) { dependency.keyValueStore.set(newValue, forKey: KeyValueStoreKey.accountCount) }
    }
    
    var backupDateStream: AnyPublisher<String, Never> {
        return dependency.backupDateSubject.eraseToAnyPublisher()
    }
    
    var accountCountStream: AnyPublisher<String, Never> {
        return dependency.accountCountSubject.eraseToAnyPublisher()
    }
    
    var errorMessageStream: AnyPublisher<String, Never> {
        return dependency.errorMessageSubject.eraseToAnyPublisher()
    }
    
    init(
        presenter: BackupRecoveryPresentable,
        dependency: BackupRecoveryInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        sendBackupInfo()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func sendBackupInfo() {
        dependency.backupDateSubject.send(backupDate.toString)
        dependency.accountCountSubject.send(accountCount)
    }
    
    func didDisappear() {
        listener?.closeBackupRecovery()
    }
    
    func backupButtonTapped() {
        dependency.accountRepository.uploadAccounts()
            .sink { [weak self] completion in
                if case .failure(let error) = completion,
                   case BackupError.empty = error {
                    self?.dependency.errorMessageSubject.send("백업할 데이터가 없습니다.")
                }
            } receiveValue: { [weak self] count in
                let currentDate = Date()
                let countString = String(count)
                self?.backupDate = currentDate
                self?.dependency.backupDateSubject.send(currentDate.toString)
                self?.accountCount = countString
                self?.dependency.accountCountSubject.send(countString)
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func recoveryButtonTapped() {
        dependency.accountRepository.downloadAccounts()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.listener?.accountsDownloaded()
            }
            .cancelOnDeactivate(interactor: self)
    }
}
