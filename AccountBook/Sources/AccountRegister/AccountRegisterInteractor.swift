//
//  AccountRegisterInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import Combine

protocol AccountRegisterRouting: ViewableRouting {
    func attachBankSelect()
    func detachBankSelect()
}

protocol AccountRegisterPresentable: Presentable {
    var listener: AccountRegisterPresentableListener? { get set }
    func displayBankName(_ name: String)
}

protocol AccountRegisterListener: AnyObject {
    func close()
}

protocol AccountRegisterInteractorDependency {
    var accountNumberSubject: CurrentValueSubject<String, Never> { get }
}

final class AccountRegisterInteractor: PresentableInteractor<AccountRegisterPresentable>, AccountRegisterInteractable, AccountRegisterPresentableListener {
    weak var router: AccountRegisterRouting?
    weak var listener: AccountRegisterListener?
    
    private let dependency: AccountRegisterInteractorDependency
    
    var accountNumberStream: AnyPublisher<String, Never> {
        return dependency.accountNumberSubject.eraseToAnyPublisher()
    }

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: AccountRegisterPresentable, dependency: AccountRegisterInteractorDependency) {
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
    
    func didDisappear() {
        listener?.close()
    }
    
    func accountNumberChanged(_ text: String) {
        let accountNumber = checkAccountNumber(text)
        dependency.accountNumberSubject.send(accountNumber)
    }
    
    func bankSelectInputTapped() {
        router?.attachBankSelect()
    }
    
    func bankDecided(_ bank: Bank) {
        presenter.displayBankName(bank.name)
    }
    
    func close() {
        router?.detachBankSelect()
    }
    
    private func checkAccountNumber(_ text: String) -> String {
        if !text.allSatisfy({ $0.isNumber }) {
            return ""
        }
        let count = min(text.count, 16)
        return text.map { String($0) }[0..<count].reduce("", +)
    }
}
