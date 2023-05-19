//
//  AccountRegisterBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import Combine

protocol AccountRegisterDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AccountRegisterComponent:
    Component<AccountRegisterDependency>,
    BankSelectDependency,
    AccountRegisterInteractorDependency
{
    var accountNumberSubject: CurrentValueSubject<String, Never> = .init("")
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
        let bankSelectBuilder = BankSelectBuilder(dependency: component)
        
        let viewController = AccountRegisterViewController()
        let interactor = AccountRegisterInteractor(presenter: viewController, dependency: component)
        
        interactor.listener = listener
        return AccountRegisterRouter(
            bankSelectBuilder: bankSelectBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
