//
//  SettingBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs
import Combine

protocol SettingDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingComponent:
    Component<SettingDependency>,
    SettingInteractorDependency,
    BackupRecoveryDependency
{
    var menuListSubject: PassthroughSubject<[SettingMenu], Never>
    var localAuthenticationRepository: LocalAuthenticationRepositoryType
    
    override init(dependency: SettingDependency) {
        self.menuListSubject = .init()
        self.localAuthenticationRepository = LocalAuthenticationRepository()
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SettingBuildable: Buildable {
    func build(withListener listener: SettingListener) -> SettingRouting
}

final class SettingBuilder: Builder<SettingDependency>, SettingBuildable {

    override init(dependency: SettingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingListener) -> SettingRouting {
        let component = SettingComponent(dependency: dependency)
        let backupRecoveryBuilder = BackupRecoveryBuilder(dependency: component)
        
        let viewController = SettingViewController()
        let interactor = SettingInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        return SettingRouter(
            backupRecoveryBuilder: backupRecoveryBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
