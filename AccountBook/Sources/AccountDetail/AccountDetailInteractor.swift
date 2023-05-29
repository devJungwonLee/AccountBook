//
//  AccountDetailInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/25.
//

import ModernRIBs
import Combine

protocol AccountDetailRouting: ViewableRouting {
    func close()
}

protocol AccountDetailPresentable: Presentable {
    var listener: AccountDetailPresentableListener? { get set }
    func displayAccount(_ account: Account)
}

protocol AccountDetailListener: AnyObject {
    func deleteButtonTapped(_ account: Account)
    func editButtonTapped(_ account: Account)
    func closeAccountDetail()
}

protocol AccountDetailInteractorDependency {
    var account: Account { get }
    var copyTextSubject: PassthroughSubject<String, Never> { get }
}

final class AccountDetailInteractor: PresentableInteractor<AccountDetailPresentable>, AccountDetailInteractable, AccountDetailPresentableListener {
    weak var router: AccountDetailRouting?
    weak var listener: AccountDetailListener?
    
    private let dependency: AccountDetailInteractorDependency
    
    var copyTextStream: AnyPublisher<String, Never> {
        return dependency.copyTextSubject.eraseToAnyPublisher()
    }
    
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
    
    func numberButtonTapped() {
        let account = dependency.account
        let text = account.bank.name + " " + account.number
        dependency.copyTextSubject.send(text)
    }
    
    func editButtonTapped() {
        listener?.editButtonTapped(dependency.account)
        router?.close()
    }
    
    func deleteButtonTapped() {
        listener?.deleteButtonTapped(dependency.account)
        router?.close()
    }
}
