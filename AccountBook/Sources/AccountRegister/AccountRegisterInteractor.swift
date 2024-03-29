//
//  AccountRegisterInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import Combine
import CombineExt

protocol AccountRegisterRouting: ViewableRouting {
    func attachBankSelect()
    func detachBankSelect()
    func close()
}

protocol AccountRegisterPresentable: Presentable {
    var listener: AccountRegisterPresentableListener? { get set }
    func displayMode(_ isNew: Bool)
}

protocol AccountRegisterListener: AnyObject {
    func accountCreated(_ account: Account)
    func accountEdited(_ account: Account)
    func closeAccountRegister()
}

protocol AccountRegisterInteractorDependency {
    var accountToEdit: Account? { get }
    var bankSubject: PassthroughSubject<Bank, Never> { get }
    var accountNumberSubject: PassthroughSubject<String, Never> { get }
    var accountNumberErrorSubject: PassthroughSubject<Bool, Never> { get }
    var accountNameSubject: PassthroughSubject<String, Never> { get }
    var accountNameErrorSubject: PassthroughSubject<Bool, Never> { get }
    var doneEventSubject: PassthroughSubject<Void, Never> { get }
}

final class AccountRegisterInteractor: PresentableInteractor<AccountRegisterPresentable>, AccountRegisterInteractable, AccountRegisterPresentableListener {
    weak var router: AccountRegisterRouting?
    weak var listener: AccountRegisterListener?
    
    private let dependency: AccountRegisterInteractorDependency
    
    var bankStream: AnyPublisher<Bank, Never> {
        return dependency.bankSubject.eraseToAnyPublisher()
    }
    
    var accountNumberStream: AnyPublisher<String, Never> {
        return dependency.accountNumberSubject.eraseToAnyPublisher()
    }
    
    var accountNumberErrorStream: AnyPublisher<Bool, Never> {
        return dependency.accountNumberErrorSubject.eraseToAnyPublisher()
    }
    
    var accountNameStream: AnyPublisher<String, Never> {
        return dependency.accountNameSubject.eraseToAnyPublisher()
    }
    
    var accountNameErrorStream: AnyPublisher<Bool, Never> {
        return dependency.accountNameErrorSubject.eraseToAnyPublisher()
    }
    
    var inputValidationStream: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(
            bankStream, accountNumberStream, accountNameStream
        ).map { (bank, accountNumber, accountName) in
            let isBankNameValid = !bank.name.isEmpty
            let isAccountNumberValid = (1...16) ~= accountNumber.count
            let isAccountNameValid = (1...20) ~= accountName.count
            return isBankNameValid && isAccountNumberValid && isAccountNameValid
        }
        .eraseToAnyPublisher()
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
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func bind() {
        dependency.doneEventSubject
            .withLatestFrom(bankStream, accountNumberStream, accountNameStream)
            .sink { [weak self] (bank, accountNumber, accountName) in
                if let accountToEdit = self?.dependency.accountToEdit {
                    let account = Account(
                        id: accountToEdit.id,
                        bank: bank,
                        number: accountNumber,
                        name: accountName,
                        date: accountToEdit.date
                    )
                    self?.listener?.accountEdited(account)
                } else {
                    let account = Account(bank: bank, number: accountNumber, name: accountName)
                    self?.listener?.accountCreated(account)
                }
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func viewDidLoad() {
        presenter.displayMode(dependency.accountToEdit == nil)
        guard let account = dependency.accountToEdit else { return }
        dependency.bankSubject.send(account.bank)
        dependency.accountNumberSubject.send(account.number)
        dependency.accountNameSubject.send(account.name)
    }
    
    func didDisappear() {
        listener?.closeAccountRegister()
    }
    
    func accountNumberChanged(_ text: String) {
        let accountNumber = text.filter { $0.isNumber }
        let isError = accountNumber.count > 16
        dependency.accountNumberSubject.send(accountNumber)
        dependency.accountNumberErrorSubject.send(isError)
    }
    
    func accountNameChanged(_ text: String) {
        let accountName = (text == " ") ? "" : text
        let isError = accountName.count > 20
        dependency.accountNameSubject.send(accountName)
        dependency.accountNameErrorSubject.send(isError)
    }
    
    func bankSelectInputTapped() {
        router?.attachBankSelect()
    }
    
    func bankDecided(_ bank: Bank) {
        dependency.bankSubject.send(bank)
        let accountName = bank.name.isEmpty ? bank.name : bank.name + " 계좌"
        dependency.accountNameSubject.send(accountName)
    }
    
    func doneButtonTapped() {
        dependency.doneEventSubject.send()
        router?.close()
    }
    
    func close() {
        router?.detachBankSelect()
    }
}
