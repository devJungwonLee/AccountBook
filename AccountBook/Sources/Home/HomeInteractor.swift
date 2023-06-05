//
//  HomeInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Foundation
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
    var accountNumberHidingFlagStream: AnyPublisher<Bool?, Never> { get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
    
    
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let dependency: HomeInteractorDependency
    
    var accountNumberHidingFlagStream: AnyPublisher<Bool, Never> {
        return dependency.accountNumberHidingFlagStream.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    var copyTextStream: AnyPublisher<String, Never> {
        return dependency.copyTextSubject.eraseToAnyPublisher()
    }
    
    var accountListStream: AnyPublisher<[Account], Never> {
        return dependency.accountListSubject.eraseToAnyPublisher()
    }
    
    private var accountOrder: [Date: Int]? {
        get {
            if let data = UserDefaults.standard.object(forKey: "accountOrder") as? Data,
               let order = try? JSONDecoder().decode([Date: Int].self, from: data) {
                return order
            } else{
                return nil
            }
        }
        set(newValue) {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: "accountOrder")
            }
        }
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
                let sortedAccounts = accounts.sorted {
                    if let accountOrder = self?.accountOrder,
                       let left = accountOrder[$0.date],
                       let right = accountOrder[$1.date] {
                        return left < right
                    }
                    return $0.date < $1.date
                }
                self?.dependency.accountListSubject.send(sortedAccounts)
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func saveAccount(_ account: Account) {
        accountOrder?[account.date] = (accountOrder?.values.max() ?? -1) + 1
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
                self?.accountOrder?.removeValue(forKey: account.date)
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
    
    func cancelButtonTapped() {
        fetchAccountList()
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
    
    func accountReordered(_ dates: [Date]) {
        var newOrder = [Date: Int]()
        (0..<dates.count).forEach { newOrder[dates[$0]] = $0 }
        accountOrder = newOrder
        fetchAccountList()
    }
    
    func closeAccountRegister() {
        router?.detachAccountRegister()
    }
    
    func closeAccountDetail() {
        router?.detachAccountDetail()
    }
}
