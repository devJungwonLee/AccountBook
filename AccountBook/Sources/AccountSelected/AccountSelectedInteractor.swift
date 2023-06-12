//
//  AccountSelectedInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs
import Foundation

protocol AccountSelectedRouting: ViewableRouting {
    func close()
}

protocol AccountSelectedPresentable: Presentable {
    var listener: AccountSelectedPresentableListener? { get set }
    func displayNotice(_ account: Account, _ copyText: String)
}

protocol AccountSelectedListener: AnyObject {
    func closeAccountSelected()
}

protocol AccountSelectedInteractorDependency {
    var account: Account { get }
}

final class AccountSelectedInteractor: PresentableInteractor<AccountSelectedPresentable>, AccountSelectedInteractable, AccountSelectedPresentableListener {

    weak var router: AccountSelectedRouting?
    weak var listener: AccountSelectedListener?
    private let dependency: AccountSelectedInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AccountSelectedPresentable,
        dependency: AccountSelectedInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func doneButtonTapped() {
        router?.close()
    }
    
    func viewDidLoad() {
        let account = dependency.account
        let text = account.bank.name + " " + account.number
        presenter.displayNotice(account, text)
    }
    
    func didDisappear() {
        listener?.closeAccountSelected()
    }
}
