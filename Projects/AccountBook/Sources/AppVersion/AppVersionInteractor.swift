//
//  AppVersionInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs
import Foundation

protocol AppVersionRouting: ViewableRouting {
    func routeToSafari(with urlString: String)
    func route(to urlString: String)
}

protocol AppVersionPresentable: Presentable {
    var listener: AppVersionPresentableListener? { get set }
    func displayAppVersion(_ version: String)
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
    
    func githubButtonTapped() {
        router?.routeToSafari(with: URLString.github)
    }
    
    func updateButtonTapped() {
        router?.route(to: URLString.appStore)
    }
    
    func fetchAppVersion() {
        let appVersion = Bundle.appVersion
        presenter.displayAppVersion(appVersion)
    }
}
