//
//  WidgetAccountSelectedInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs
import Foundation

protocol WidgetAccountSelectedRouting: ViewableRouting {
    func close()
}

protocol WidgetAccountSelectedPresentable: Presentable {
    var listener: WidgetAccountSelectedPresentableListener? { get set }
    func displayNotice(_ account: Account, _ copyText: String)
}

protocol WidgetAccountSelectedListener: AnyObject {
    func closeWidgetAccountSelected()
}

protocol WidgetAccountSelectedInteractorDependency {
    var id: String { get }
    var accountRepository: AccountRepositoryType { get }
}

final class WidgetAccountSelectedInteractor: PresentableInteractor<WidgetAccountSelectedPresentable>, WidgetAccountSelectedInteractable, WidgetAccountSelectedPresentableListener {

    weak var router: WidgetAccountSelectedRouting?
    weak var listener: WidgetAccountSelectedListener?
    private let dependency: WidgetAccountSelectedInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: WidgetAccountSelectedPresentable,
        dependency: WidgetAccountSelectedInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func doneButtonTapped() {
        router?.close()
    }
    
    func didDisappear() {
        listener?.closeWidgetAccountSelected()
    }
    
    private func bind() {
        guard let uuid = UUID(uuidString: dependency.id) else { return }
        dependency.accountRepository.fetchAccount(uuid)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] account in
                let text = account.bank.name + " " + account.number
                self?.presenter.displayNotice(account, text)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
