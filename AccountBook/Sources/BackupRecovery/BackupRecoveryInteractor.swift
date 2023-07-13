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
    var backupRecoveryRepository: BackupRecoveryRepositoryType { get }
    var backupDateSubject: ReplaySubject<String, Never> { get }
    var accountCountSubject: ReplaySubject<String, Never> { get }
    var errorMessageSubject: PassthroughSubject<String, Never> { get }
}

final class BackupRecoveryInteractor: PresentableInteractor<BackupRecoveryPresentable>, BackupRecoveryInteractable, BackupRecoveryPresentableListener {
    weak var router: BackupRecoveryRouting?
    weak var listener: BackupRecoveryListener?
    private let dependency: BackupRecoveryInteractorDependency
    
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
        fetchBackupInfo()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchBackupInfo() {
        dependency.backupRecoveryRepository.fetchBackupDate()
            .sink { [weak self] completion in
                if case .failure(let error) = completion,
                   case DatabaseError.notFound = error {
                    self?.dependency.backupDateSubject.send(Date().toString)
                }
            } receiveValue: { [weak self] date in
                let dateString = (date ?? Date()).toString
                self?.dependency.backupDateSubject.send(dateString)
            }
            .cancelOnDeactivate(interactor: self)
        
        dependency.backupRecoveryRepository.fetchAccountCount()
            .sink { completion in
                if case .failure(let error) = completion { print(error) }
            } receiveValue: { [weak self] count in
                let countString = count == 0 ? "" : String(count)
                self?.dependency.accountCountSubject.send(countString)
            }
            .cancelOnDeactivate(interactor: self)
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
                self?.saveBackupDate(currentDate)
                self?.dependency.accountCountSubject.send(String(count))
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func saveBackupDate(_ date: Date) {
        dependency.backupRecoveryRepository.saveBackupDate(date)
            .sink { completion in
                if case .failure(let error) = completion { print(error) }
            } receiveValue: { [weak self] in
                self?.dependency.backupDateSubject.send(date.toString)
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
    
    func deleteButtonTapped() {
        dependency.backupRecoveryRepository.deleteBackupData()
            .sink { completion in
                if case .failure(let error) = completion { print(error) }
            } receiveValue: { [weak self] in
                self?.dependency.accountCountSubject.send("")
                self?.dependency.backupDateSubject.send(Date().toString)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
