//
//  AccountRegisterRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs

protocol AccountRegisterInteractable: Interactable {
    var router: AccountRegisterRouting? { get set }
    var listener: AccountRegisterListener? { get set }
}

protocol AccountRegisterViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AccountRegisterRouter: ViewableRouter<AccountRegisterInteractable, AccountRegisterViewControllable>, AccountRegisterRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AccountRegisterInteractable, viewController: AccountRegisterViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
