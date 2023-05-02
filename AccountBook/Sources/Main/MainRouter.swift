//
//  MainRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol MainInteractable: Interactable, HomeListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable {
    func configureChildTabs(viewControllers: [ViewControllable])
}

final class MainRouter: ViewableRouter<MainInteractable, MainViewControllable>, MainRouting {
    private let homeBuilder: HomeBuildable
    private var homeRouter: HomeRouting?
    
    init(
        homeBuilder: HomeBuildable,
        interactor: MainInteractable,
        viewController: MainViewControllable
    ) {
        self.homeBuilder = homeBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachChildren() {
        attachHome()
        let viewControllers = [homeRouter].compactMap { $0?.viewControllable }
        viewController.configureChildTabs(viewControllers: viewControllers)
    }
    
    private func attachHome() {
        let homeRouter = homeBuilder.build(withListener: interactor)
        self.homeRouter = homeRouter
        attachChild(homeRouter)
    }
}
