//
//  AccountSelectedRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs

protocol AccountSelectedInteractable: Interactable {
    var router: AccountSelectedRouting? { get set }
    var listener: AccountSelectedListener? { get set }
}

protocol AccountSelectedViewControllable: ViewControllable {
    func dismiss()
}

final class AccountSelectedRouter: ViewableRouter<AccountSelectedInteractable, AccountSelectedViewControllable>, AccountSelectedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AccountSelectedInteractable, viewController: AccountSelectedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func close() {
        viewController.dismiss()
    }
}
