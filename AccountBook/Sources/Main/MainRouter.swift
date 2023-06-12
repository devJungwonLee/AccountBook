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
    WidgetAccountSelectedListener
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
    
    private let widgetAccountSelectedBuilder: WidgetAccountSelectedBuildable
    private var widgetAccountSelectedRouter: WidgetAccountSelectedRouting?
    
    init(
        homeBuilder: HomeBuildable,
        settingBuilder: SettingBuildable,
        widgetAccountSelectedBuilder: WidgetAccountSelectedBuildable,
        interactor: MainInteractable,
        viewController: MainViewControllable
    ) {
        self.homeBuilder = homeBuilder
        self.settingBuilder = settingBuilder
        self.widgetAccountSelectedBuilder = widgetAccountSelectedBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachChildren() {
        attachHome()
        attachSetting()
        let viewControllers = [homeRouter, settingRouter].compactMap { $0?.viewControllable }
        viewController.configureChildTabs(viewControllers: viewControllers)
    }
    
    func attachWidgetAccountSelected(id: String) {
        if widgetAccountSelectedRouter != nil {
            detachWidgetAccountSelected()
        }
        let widgetAccountSelectedRouter = widgetAccountSelectedBuilder.build(
            withListener: interactor, id: id
        )
        self.widgetAccountSelectedRouter = widgetAccountSelectedRouter
        attachChild(widgetAccountSelectedRouter)
        viewController.present(viewController: widgetAccountSelectedRouter.viewControllable)
    }
    
    func detachWidgetAccountSelected() {
        guard let widgetAccountSelectedRouter else { return }
        detachChild(widgetAccountSelectedRouter)
        self.widgetAccountSelectedRouter = nil
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
