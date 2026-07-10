//
//  HomeRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol HomeInteractable:
    Interactable,
    AccountRegisterListener,
    AccountDetailListener
{
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func push(viewController: ViewControllable)
    func present(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    private let accountRegisterBuilder: AccountRegisterBuildable
    private var accountRegisterRouter: AccountRegisterRouting?
    
    private let accountDetailBuilder: AccountDetailBuildable
    private var accountDetailRouter: AccountDetailRouting?
    
    init(
        accountRegisterBuilder: AccountRegisterBuildable,
        accountDetailBuilder: AccountDetailBuildable,
        interactor: HomeInteractable,
        viewController: HomeViewControllable
    ) {
        self.accountRegisterBuilder = accountRegisterBuilder
        self.accountDetailBuilder = accountDetailBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAccountRegister(account: Account?) {
        let accountRegisterRouter = accountRegisterBuilder.build(
            withListener: interactor,
            account: account
        )
        self.accountRegisterRouter = accountRegisterRouter
        attachChild(accountRegisterRouter)
        viewController.push(viewController: accountRegisterRouter.viewControllable)
    }
    
    func detachAccountRegister() {
        guard let accountRegisterRouter else { return }
        detachChild(accountRegisterRouter)
        self.accountRegisterRouter = nil
    }
    
    func attachAccountDetail(account: Account) {
        let accountDetailRouter = accountDetailBuilder.build(withListener: interactor, account: account)
        self.accountDetailRouter = accountDetailRouter
        attachChild(accountDetailRouter)
        viewController.present(viewController: accountDetailRouter.viewControllable)
    }
    
    func detachAccountDetail() {
        guard let accountDetailRouter else { return }
        detachChild(accountDetailRouter)
        self.accountDetailRouter = nil
    }
}
