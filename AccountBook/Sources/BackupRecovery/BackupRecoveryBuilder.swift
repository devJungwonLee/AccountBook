//
//  BackupRecoveryBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs

protocol BackupRecoveryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BackupRecoveryComponent: Component<BackupRecoveryDependency> {

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
        _ = BackupRecoveryComponent(dependency: dependency)
        let viewController = BackupRecoveryViewController()
        let interactor = BackupRecoveryInteractor(presenter: viewController)
        interactor.listener = listener
        return BackupRecoveryRouter(interactor: interactor, viewController: viewController)
    }
}
