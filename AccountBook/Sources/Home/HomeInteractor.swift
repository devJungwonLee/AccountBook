//
//  HomeInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol HomeRouting: ViewableRouting {
    func attachAccountRegister(account: Account?)
    func detachAccountRegister()
    func attachAccountDetail(account: Account)
    func detachAccountDetail()
}

protocol HomePresentable: Presentable {
    var listener: HomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol HomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol HomeInteractorDependency {
    var copyTextSubject: PassthroughSubject<String, Never> { get }
    var accountListSubject: CurrentValueSubject<[Account], Never> { get }
    var accountRepository: AccountRepositoryType { get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let dependency: HomeInteractorDependency
    
    var copyTextStream: AnyPublisher<String, Never> {
        return dependency.copyTextSubject.eraseToAnyPublisher()
    }
    
    var accountListStream: AnyPublisher<[Account], Never> {
        return dependency.accountListSubject.eraseToAnyPublisher()
    }
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: HomePresentable, dependency: HomeInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchAccountList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func fetchAccountList() {
        dependency.accountRepository.fetchAccountList()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] accounts in
                let sortedAccounts = accounts.sorted { $0.date < $1.date }
                self?.dependency.accountListSubject.send(sortedAccounts)
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func saveAccount(_ account: Account) {
        dependency.accountRepository.saveAccount(account)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.fetchAccountList()
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func editAccount(_ account: Account) {
        dependency.accountRepository.updateAccount(account)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.fetchAccountList()
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func deleteAccount(_ account: Account) {
        dependency.accountRepository.deleteAccount(account)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.fetchAccountList()
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func addButtonTapped() {
        router?.attachAccountRegister(account: nil)
    }
    
    func trailingSwiped(_ index: Int) {
        let account = dependency.accountListSubject.value[index]
        deleteAccount(account)
    }
    
    func deleteButtonTapped(_ account: Account) {
        deleteAccount(account)
    }
    
    func editButtonTapped(_ account: Account) {
        router?.attachAccountRegister(account: account)
    }
    
    func copyButtonTapped(_ index: Int) {
        let account = dependency.accountListSubject.value[index]
        let text = account.bank.name + " " + account.number
        dependency.copyTextSubject.send(text)
    }
    
    func accountSelected(_ index: Int) {
        let account = dependency.accountListSubject.value[index]
        router?.attachAccountDetail(account: account)
    }
    
    func accountCreated(_ account: Account) {
        saveAccount(account)
    }
    
    func accountEdited(_ account: Account) {
        editAccount(account)
    }
    
    func closeAccountRegister() {
        router?.detachAccountRegister()
    }
    
    func closeAccountDetail() {
        router?.detachAccountDetail()
    }
}
