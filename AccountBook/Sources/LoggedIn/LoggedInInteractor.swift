//
//  LoggedInInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol LoggedInRouting: Routing {
    func cleanupViews()
    func routeToMain()
}

protocol LoggedInListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.routeToMain()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
