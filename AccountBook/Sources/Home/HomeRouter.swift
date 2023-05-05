//
//  HomeRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol HomeInteractable: Interactable, AccountRegisterListener {
    var router: HomeRouting? { get set }
    var listener: HomeListener? { get set }
}

protocol HomeViewControllable: ViewControllable {
    func push(viewController: ViewControllable)
}

final class HomeRouter: ViewableRouter<HomeInteractable, HomeViewControllable>, HomeRouting {
    private let accountRegisterBuilder: AccountRegisterBuildable
    private var accountRegisterRouter: AccountRegisterRouting?
    
    init(
        accountRegisterBuilder: AccountRegisterBuildable,
        interactor: HomeInteractable,
        viewController: HomeViewControllable
    ) {
        self.accountRegisterBuilder = accountRegisterBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAccountRegister() {
        let accountRegisterRouter = accountRegisterBuilder.build(withListener: interactor)
        self.accountRegisterRouter = accountRegisterRouter
        attachChild(accountRegisterRouter)
        viewController.push(viewController: accountRegisterRouter.viewControllable)
    }
    
    func detachAccountRegister() {
        guard let accountRegisterRouter else { return }
        detachChild(accountRegisterRouter)
        self.accountRegisterRouter = nil
    }
}
