//
//  LoggedInRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol LoggedInInteractable: Interactable, MainListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {
    private let mainBuilder: MainBuildable
    private var mainRouter: MainRouting?
    private let viewController: LoggedInViewControllable

    init(
        mainBuilder: MainBuildable,
        interactor: LoggedInInteractable,
        viewController: LoggedInViewControllable
    ) {
        self.mainBuilder = mainBuilder
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
    
    func routeToMain() {
        let mainRouter = mainBuilder.build(withListener: interactor)
        self.mainRouter = mainRouter
        attachChild(mainRouter)
        viewController.present(viewController: mainRouter.viewControllable)
    }
}
