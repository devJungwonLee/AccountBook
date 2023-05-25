//
//  HomeInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol HomeRouting: ViewableRouting {
    func attachAccountRegister()
    func detachAccountRegister()
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
                self?.dependency.accountListSubject.send(accounts)
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
        router?.attachAccountRegister()
    }
    
    func trailingSwiped(_ index: Int) {
        let account = dependency.accountListSubject.value[index]
        deleteAccount(account)
    }
    
    func copyButtonTapped(_ index: Int) {
        let account = dependency.accountListSubject.value[index]
        let text = account.bank.name + " " + account.number
        dependency.copyTextSubject.send(text)
    }
    
    func accountCreated(_ account: Account) {
        saveAccount(account)
    }
    
    func close() {
        router?.detachAccountRegister()
    }
}
