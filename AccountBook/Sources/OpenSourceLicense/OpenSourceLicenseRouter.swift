//
//  OpenSourceLicenseRouter.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import ModernRIBs

protocol OpenSourceLicenseInteractable: Interactable {
    var router: OpenSourceLicenseRouting? { get set }
    var listener: OpenSourceLicenseListener? { get set }
}

protocol OpenSourceLicenseViewControllable: ViewControllable {
    func presentSafari(with urlString: String)
}

final class OpenSourceLicenseRouter: ViewableRouter<OpenSourceLicenseInteractable, OpenSourceLicenseViewControllable>, OpenSourceLicenseRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OpenSourceLicenseInteractable, viewController: OpenSourceLicenseViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToSafari(with urlString: String) {
        viewController.presentSafari(with: urlString)
    }
}
