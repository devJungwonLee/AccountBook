//
//  AccountRegisterInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs

protocol AccountRegisterRouting: ViewableRouting {
    func attachBankSelect()
}

protocol AccountRegisterPresentable: Presentable {
    var listener: AccountRegisterPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AccountRegisterListener: AnyObject {
    func close()
}

final class AccountRegisterInteractor: PresentableInteractor<AccountRegisterPresentable>, AccountRegisterInteractable, AccountRegisterPresentableListener {

    weak var router: AccountRegisterRouting?
    weak var listener: AccountRegisterListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AccountRegisterPresentable) {
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
        listener?.close()
    }
    
    func bankSelectInputTapped() {
        router?.attachBankSelect()
    }
}
