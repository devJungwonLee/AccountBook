//
//  BankSelectRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import ModernRIBs

protocol BankSelectInteractable: Interactable {
    var router: BankSelectRouting? { get set }
    var listener: BankSelectListener? { get set }
}

protocol BankSelectViewControllable: ViewControllable {
    func dismiss()
}

final class BankSelectRouter: ViewableRouter<BankSelectInteractable, BankSelectViewControllable>, BankSelectRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BankSelectInteractable, viewController: BankSelectViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func close() {
        viewController.dismiss()
    }
}
