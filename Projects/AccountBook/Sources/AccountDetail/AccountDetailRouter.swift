//
//  AccountDetailRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/25.
//

import ModernRIBs

protocol AccountDetailInteractable: Interactable {
    var router: AccountDetailRouting? { get set }
    var listener: AccountDetailListener? { get set }
}

protocol AccountDetailViewControllable: ViewControllable {
    func dismiss()
}

final class AccountDetailRouter: ViewableRouter<AccountDetailInteractable, AccountDetailViewControllable>, AccountDetailRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AccountDetailInteractable, viewController: AccountDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func close() {
        viewController.dismiss()
    }
}
