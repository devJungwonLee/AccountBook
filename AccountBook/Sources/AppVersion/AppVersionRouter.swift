//
//  AppVersionRouter.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs

protocol AppVersionInteractable: Interactable {
    var router: AppVersionRouting? { get set }
    var listener: AppVersionListener? { get set }
}

protocol AppVersionViewControllable: ViewControllable {
    func open(with urlString: String)
    func presentSafari(with urlString: String)
}

final class AppVersionRouter: ViewableRouter<AppVersionInteractable, AppVersionViewControllable>, AppVersionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppVersionInteractable, viewController: AppVersionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func route(to urlString: String) {
        viewController.open(with: urlString)
    }
    
    func routeToSafari(with urlString: String) {
        viewController.presentSafari(with: urlString)
    }
}
