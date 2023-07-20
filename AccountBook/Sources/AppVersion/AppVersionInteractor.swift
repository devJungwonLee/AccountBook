//
//  AppVersionInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs

protocol AppVersionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppVersionPresentable: Presentable {
    var listener: AppVersionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppVersionListener: AnyObject {
    func closeAppVersion()
}

final class AppVersionInteractor: PresentableInteractor<AppVersionPresentable>, AppVersionInteractable, AppVersionPresentableListener {

    weak var router: AppVersionRouting?
    weak var listener: AppVersionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppVersionPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didDisappear() {
        listener?.closeAppVersion()
    }
}
