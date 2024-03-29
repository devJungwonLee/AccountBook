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
    var accountToEdit: Account?
    var bankSubject: PassthroughSubject<Bank, Never> = .init()
    var accountNumberSubject: PassthroughSubject<String, Never> = .init()
    var accountNumberErrorSubject: PassthroughSubject<Bool, Never> = .init()
    var accountNameSubject: PassthroughSubject<String, Never> = .init()
    var accountNameErrorSubject: PassthroughSubject<Bool, Never> = .init()
    var doneEventSubject: PassthroughSubject<Void, Never> = .init()
    
    init(dependency: AccountRegisterDependency, account: Account? = nil) {
        self.accountToEdit = account
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AccountRegisterBuildable: Buildable {
    func build(withListener listener: AccountRegisterListener, account: Account?) -> AccountRegisterRouting
}

final class AccountRegisterBuilder: Builder<AccountRegisterDependency>, AccountRegisterBuildable {

    override init(dependency: AccountRegisterDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AccountRegisterListener, account: Account?) -> AccountRegisterRouting {
        let component = AccountRegisterComponent(dependency: dependency, account: account)
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
