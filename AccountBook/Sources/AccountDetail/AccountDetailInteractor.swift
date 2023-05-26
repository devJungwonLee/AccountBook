//
//  AccountDetailInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/25.
//

import ModernRIBs

protocol AccountDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AccountDetailPresentable: Presentable {
    var listener: AccountDetailPresentableListener? { get set }
    func displayAccount(_ account: Account)
}

protocol AccountDetailListener: AnyObject {
    func closeAccountDetail()
}

protocol AccountDetailInteractorDependency {
    var account: Account { get }
}

final class AccountDetailInteractor: PresentableInteractor<AccountDetailPresentable>, AccountDetailInteractable, AccountDetailPresentableListener {
    weak var router: AccountDetailRouting?
    weak var listener: AccountDetailListener?
    
    private let dependency: AccountDetailInteractorDependency
    
    init(presenter: AccountDetailPresentable, dependency: AccountDetailInteractorDependency) {
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
    
    func viewDidLoad() {
        presenter.displayAccount(dependency.account)
    }
    
    func didDisappear() {
        listener?.closeAccountDetail()
    }
}
