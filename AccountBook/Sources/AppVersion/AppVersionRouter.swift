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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppVersionRouter: ViewableRouter<AppVersionInteractable, AppVersionViewControllable>, AppVersionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AppVersionInteractable, viewController: AppVersionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
