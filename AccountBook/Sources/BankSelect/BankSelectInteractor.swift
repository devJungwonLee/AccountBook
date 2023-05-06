//
//  BankSelectInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import ModernRIBs

protocol BankSelectRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BankSelectPresentable: Presentable {
    var listener: BankSelectPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BankSelectListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BankSelectInteractor: PresentableInteractor<BankSelectPresentable>, BankSelectInteractable, BankSelectPresentableListener {

    weak var router: BankSelectRouting?
    weak var listener: BankSelectListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BankSelectPresentable) {
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
}
