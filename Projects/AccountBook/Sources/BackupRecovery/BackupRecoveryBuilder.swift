//
//  BackupRecoveryBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs
import Foundation
import Combine
import CombineExt

protocol BackupRecoveryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BackupRecoveryComponent:
    Component<BackupRecoveryDependency>,
    BackupRecoveryInteractorDependency
{
    var accountRepository: AccountRepositoryType
    var backupRecoveryRepository: BackupRecoveryRepositoryType
    var localAuthenticationRepository: LocalAuthenticationRepositoryType
    var backupDateSubject: ReplaySubject<String, Never>
    var accountCountSubject: ReplaySubject<String, Never>
    var messageSubject: PassthroughSubject<String, Never>
    
    override init(dependency: BackupRecoveryDependency) {
        self.accountRepository = AccountRepository()
        self.backupRecoveryRepository = BackupRecoveryRepository()
        self.localAuthenticationRepository = LocalAuthenticationRepository()
        self.backupDateSubject = .init(bufferSize: 1)
        self.accountCountSubject = .init(bufferSize: 1)
        self.messageSubject = .init()
        super.init(dependency: dependency)
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BackupRecoveryBuildable: Buildable {
    func build(withListener listener: BackupRecoveryListener) -> BackupRecoveryRouting
}

final class BackupRecoveryBuilder: Builder<BackupRecoveryDependency>, BackupRecoveryBuildable {

    override init(dependency: BackupRecoveryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BackupRecoveryListener) -> BackupRecoveryRouting {
        let component = BackupRecoveryComponent(dependency: dependency)
        let viewController = BackupRecoveryViewController()
        let interactor = BackupRecoveryInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return BackupRecoveryRouter(interactor: interactor, viewController: viewController)
    }
}
