//
//  AccountRegisterRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs

protocol AccountRegisterInteractable: Interactable, BankSelectListener {
    var router: AccountRegisterRouting? { get set }
    var listener: AccountRegisterListener? { get set }
}

protocol AccountRegisterViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class AccountRegisterRouter: ViewableRouter<AccountRegisterInteractable, AccountRegisterViewControllable>, AccountRegisterRouting {
    private let bankSelectBuilder: BankSelectBuildable
    private var bankSelectRouter: BankSelectRouting?

    init(
        bankSelectBuilder: BankSelectBuildable,
        interactor: AccountRegisterInteractable,
        viewController: AccountRegisterViewControllable
    ) {
        self.bankSelectBuilder = bankSelectBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachBankSelect() {
        let bankSelectRouter = bankSelectBuilder.build(withListener: interactor)
        self.bankSelectRouter = bankSelectRouter
        attachChild(bankSelectRouter)
        viewController.present(viewController: bankSelectRouter.viewControllable)
    }
}
