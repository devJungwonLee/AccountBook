//
//  AccountRegisterBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs

protocol AccountRegisterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AccountRegisterComponent: Component<AccountRegisterDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AccountRegisterBuildable: Buildable {
    func build(withListener listener: AccountRegisterListener) -> AccountRegisterRouting
}

final class AccountRegisterBuilder: Builder<AccountRegisterDependency>, AccountRegisterBuildable {

    override init(dependency: AccountRegisterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountRegisterListener) -> AccountRegisterRouting {
        let component = AccountRegisterComponent(dependency: dependency)
        let viewController = AccountRegisterViewController()
        let interactor = AccountRegisterInteractor(presenter: viewController)
        interactor.listener = listener
        return AccountRegisterRouter(interactor: interactor, viewController: viewController)
    }
}