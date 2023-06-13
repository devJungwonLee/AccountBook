//
//  AccountSelectedBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs

protocol AccountSelectedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AccountSelectedComponent:
    Component<AccountSelectedDependency>,
    AccountSelectedInteractorDependency
{
    var account: Account
    
    init(dependency: AccountSelectedDependency, account: Account) {
        self.account = account
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AccountSelectedBuildable: Buildable {
    func build(withListener listener: AccountSelectedListener, account: Account) -> AccountSelectedRouting
}

final class AccountSelectedBuilder: Builder<AccountSelectedDependency>, AccountSelectedBuildable {

    override init(dependency: AccountSelectedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountSelectedListener, account: Account) -> AccountSelectedRouting {
        let component = AccountSelectedComponent(dependency: dependency, account: account)
        let viewController = AccountSelectedViewController()
        let interactor = AccountSelectedInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AccountSelectedRouter(interactor: interactor, viewController: viewController)
    }
}
