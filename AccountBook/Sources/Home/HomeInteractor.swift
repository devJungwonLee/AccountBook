//
//  HomeInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Foundation
import Combine
import CombineExt
import WidgetKit

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
    var localAuthenticationRepository: LocalAuthenticationRepositoryType { get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    private let dependency: HomeInteractorDependency
    private var standard: UserDefaults { UserDefaults.standard }
    
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
        get { standard.value(forKey: UserDefaultsKey.accountOrder, [Date: Int].self) }
        set(newValue) { standard.setValue(forKey: UserDefaultsKey.accountOrder, newValue) }
    }
    
    private var lastUnlockTime: Date? {
        get { standard.object(forKey: UserDefaultsKey.lastUnlockTime) as? Date }
        set(newvalue) { standard.setValue(newvalue, forKey: UserDefaultsKey.lastUnlockTime) }
    }
    
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
                WidgetCenter.shared.reloadAllTimelines()
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
                WidgetCenter.shared.reloadAllTimelines()
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
        Just(())
            .withLatestFrom(accountNumberHidingFlagStream)
            .compactMap { [weak self] hidingFlag in
                self?.shouldAuthenticate(hidingFlag)
            }
            .sink { shouldAuthenticate in
                if shouldAuthenticate { self.authenticate(account: account) }
                else { self.router?.attachAccountDetail(account: account) }
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    private func shouldAuthenticate(_ hidingFlag: Bool) -> Bool {
        if !hidingFlag { return false }
        guard let elapsedMinutes = lastUnlockTime?.elapsedMinutes else { return true }
        return elapsedMinutes >= 5
    }
    
    private func authenticate(account: Account) {
        dependency.localAuthenticationRepository.authenticate(
            localizedReason: "계좌를 확인하기 위해 인증을 진행합니다."
        ).sink { completion in
            if case .failure(let error) = completion {
                print(error)
            }
        } receiveValue: { isSuccess in
            if isSuccess {
                self.lastUnlockTime = Date()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.router?.attachAccountDetail(account: account)
                }
            }
        }
        .cancelOnDeactivate(interactor: self)
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
