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
    // TODO: Declare methods the interactor can invoke the presenter to present data.
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
        router?.attachLoggedIn()

        Task { [weak self] in
            guard let self else { return }

            do {
                try await self.dependency.bankAssetRepository.synchronize()
            } catch {
                // TODO: 에러 처리
            }
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
