//
//  MainRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol MainInteractable:
    Interactable,
    HomeListener,
    SettingListener,
    AccountSelectedListener
{
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func configureChildTabs(viewControllers: [ViewControllable])
    func present(viewController: ViewControllable)
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    private let homeBuilder: HomeBuildable
    private var homeRouter: HomeRouting?
    
    private let settingBuilder: SettingBuildable
    private var settingRouter: SettingRouting?
    
    private let accountSelectedBuilder: AccountSelectedBuildable
    private var accountSelectedRouter: AccountSelectedRouting?
    
    init(
        homeBuilder: HomeBuildable,
        settingBuilder: SettingBuildable,
        accountSelectedBuilder: AccountSelectedBuildable,
        interactor: MainInteractable,
        viewController: MainViewControllable
    ) {
        self.homeBuilder = homeBuilder
        self.settingBuilder = settingBuilder
        self.accountSelectedBuilder = accountSelectedBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachChildren() {
        attachHome()
        attachSetting()
        let viewControllers = [homeRouter, settingRouter].compactMap { $0?.viewControllable }
        viewController.configureChildTabs(viewControllers: viewControllers)
    }
    
    func attachAccountSelected(_ account: Account) {
        if accountSelectedRouter != nil {
            detachAccountSelected()
        }
        let accountSelectedRouter = accountSelectedBuilder.build(
            withListener: interactor, account: account
        )
        self.accountSelectedRouter = accountSelectedRouter
        attachChild(accountSelectedRouter)
        viewController.present(viewController: accountSelectedRouter.viewControllable)
    }
    
    func detachAccountSelected() {
        guard let accountSelectedRouter else { return }
        detachChild(accountSelectedRouter)
        self.accountSelectedRouter = nil
    }
    
    private func attachHome() {
        let homeRouter = homeBuilder.build(withListener: interactor)
        self.homeRouter = homeRouter
        attachChild(homeRouter)
    }
    
    private func attachSetting() {
        let settingRouter = settingBuilder.build(withListener: interactor)
        self.settingRouter = settingRouter
        attachChild(settingRouter)
    }
}
