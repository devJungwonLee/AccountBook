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
    var localAuthenticationRepository: LocalAuthenticationRepositoryType { get }
    var backupDateSubject: ReplaySubject<String, Never> { get }
    var accountCountSubject: ReplaySubject<String, Never> { get }
    var messageSubject: PassthroughSubject<String, Never> { get }
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
    
    var messageStream: AnyPublisher<String, Never> {
        return dependency.messageSubject.eraseToAnyPublisher()
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
                self?.dependency.backupDateSubject.send(date.toString)
            }
            .cancelOnDeactivate(interactor: self)
        
        dependency.backupRecoveryRepository.fetchAccountCount()
            .sink { [weak self] completion in
                if case .failure(let error) = completion,
                   case DatabaseError.empty = error {
                    self?.dependency.accountCountSubject.send("")
                }
            } receiveValue: { [weak self] count in
                self?.dependency.accountCountSubject.send(String(count))
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func didDisappear() {
        listener?.closeBackupRecovery()
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
    
    func backupButtonTapped() {
        dependency.localAuthenticationRepository.authenticate(localizedReason: "데이터 백업을 위해 인증을 진행합니다.")
            .delay(for: 0.7, scheduler: DispatchQueue.main)
            .filter { $0 }
            .flatMap { [unowned self] _ in
                return dependency.backupRecoveryRepository.uploadAccounts()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion,
                   case DatabaseError.empty = error {
                    self?.dependency.messageSubject.send("백업할 데이터가 없습니다.")
                }
            } receiveValue: { [weak self] count in
                let currentDate = Date()
                self?.saveBackupDate(currentDate)
                self?.dependency.accountCountSubject.send(String(count))
                self?.dependency.messageSubject.send("백업이 완료되었습니다.")
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func recoveryButtonTapped() {
        dependency.localAuthenticationRepository.authenticate(localizedReason: "데이터 복구를 위해 인증을 진행합니다.")
            .delay(for: 0.7, scheduler: DispatchQueue.main)
            .filter { $0 }
            .flatMap { [unowned self] _ in
                return dependency.backupRecoveryRepository.downloadAccounts()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion,
                   case DatabaseError.empty = error {
                    self?.dependency.messageSubject.send("복구할 데이터가 없습니다.")
                }
            } receiveValue: { [weak self] in
                self?.listener?.accountsDownloaded()
                self?.dependency.messageSubject.send("복구가 완료되었습니다.")
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func deleteButtonTapped() {
        dependency.localAuthenticationRepository.authenticate(localizedReason: "데이터 삭제를 위해 인증을 진행합니다.")
            .delay(for: 0.7, scheduler: DispatchQueue.main)
            .filter { $0 }
            .flatMap { [unowned self] _ in
                return dependency.backupRecoveryRepository.deleteBackupData()
            }
            .sink { completion in
                if case .failure(let error) = completion { print(error) }
            } receiveValue: { [weak self] in
                self?.dependency.accountCountSubject.send("")
                self?.dependency.backupDateSubject.send(Date().toString)
                self?.dependency.messageSubject.send("삭제가 완료되었습니다.")
            }
            .cancelOnDeactivate(interactor: self)
    }
}
