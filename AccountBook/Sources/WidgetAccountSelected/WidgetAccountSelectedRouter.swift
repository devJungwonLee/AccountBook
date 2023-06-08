//
//  WidgetAccountSelectedRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs

protocol WidgetAccountSelectedInteractable: Interactable {
    var router: WidgetAccountSelectedRouting? { get set }
    var listener: WidgetAccountSelectedListener? { get set }
}

protocol WidgetAccountSelectedViewControllable: ViewControllable {
    func dismiss()
}

final class WidgetAccountSelectedRouter: ViewableRouter<WidgetAccountSelectedInteractable, WidgetAccountSelectedViewControllable>, WidgetAccountSelectedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: WidgetAccountSelectedInteractable, viewController: WidgetAccountSelectedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func close() {
        viewController.dismiss()
    }
}
