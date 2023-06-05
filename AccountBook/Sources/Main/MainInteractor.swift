//
//  MainInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol MainRouting: ViewableRouting {
    func attachChildren()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
    var accountNumberHidingFlagSubject: CurrentValueSubject<Bool?, Never> { get }
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
    weak var router: MainRouting?
    weak var listener: MainListener?
    private let dependency: MainInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MainPresentable, dependency: MainInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachChildren()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func accountNumberHidingFlagChanged(_ shouldHide: Bool) {
        dependency.accountNumberHidingFlagSubject.send(shouldHide)
    }
}
