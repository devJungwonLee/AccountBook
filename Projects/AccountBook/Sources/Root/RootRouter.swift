//
//  RootRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import UIKit
import ModernRIBs

protocol RootInteractable: Interactable, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    private let loggedInBuilder: LoggedInBuildable
    private var loggedInRouter: LoggedInRouting?
    
    init(
        loggedInBuilder: LoggedInBuildable,
        interactor: RootInteractable,
        viewController: RootViewControllable
    ) {
        self.loggedInBuilder = loggedInBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachLoggedIn() {
        let loggedInRouter = loggedInBuilder.build(withListener: interactor)
        attachChild(loggedInRouter)
    }
}
