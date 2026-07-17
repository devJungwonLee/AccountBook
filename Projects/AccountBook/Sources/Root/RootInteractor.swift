//
//  RootInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import UIKit
import ModernRIBs

protocol RootRouting: ViewableRouting {
    func attachLoggedIn()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    func setLoading(_ isLoading: Bool)
}

protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RootInteractorDependency {
    var bankAssetRepository: BankAssetRepositoryType { get }
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    private let dependency: RootInteractorDependency

    init(presenter: RootPresentable, dependency: RootInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        synchronizeAssets()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

private extension RootInteractor {
    func synchronizeAssets() {
        Task { @MainActor [weak self] in
            self?.presenter.setLoading(true)
            try? await self?.dependency.bankAssetRepository.synchronize()
            self?.presenter.setLoading(false)
            self?.router?.attachLoggedIn()
        }
    }
}
