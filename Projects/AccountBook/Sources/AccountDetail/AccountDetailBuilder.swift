//
//  AccountDetailBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/25.
//

import ModernRIBs
import Combine

protocol AccountDetailDependency: Dependency {
    
}

final class AccountDetailComponent:
    Component<AccountDetailDependency>,
    AccountDetailInteractorDependency
{
    var account: Account
    var copyTextSubject: PassthroughSubject<String, Never> = .init()
    
    init(dependency: AccountDetailDependency, account: Account) {
        self.account = account
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AccountDetailBuildable: Buildable {
    func build(withListener listener: AccountDetailListener, account: Account) -> AccountDetailRouting
}

final class AccountDetailBuilder: Builder<AccountDetailDependency>, AccountDetailBuildable {

    override init(dependency: AccountDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountDetailListener, account: Account) -> AccountDetailRouting {
        let component = AccountDetailComponent(dependency: dependency, account: account)
        let viewController = AccountDetailViewController()
        let interactor = AccountDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AccountDetailRouter(interactor: interactor, viewController: viewController)
    }
}
