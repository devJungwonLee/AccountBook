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
    var accountListSubject: CurrentValueSubject<[Account], Never> { get }
}

final class HomeInteractor: PresentableInteractor<HomePresentable>, HomeInteractable, HomePresentableListener {
    weak var router: HomeRouting?
    weak var listener: HomeListener?
    
    private let dependency: HomeInteractorDependency
    
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
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func addButtonTapped() {
        router?.attachAccountRegister()
    }
    
    func trailingSwiped(_ index: Int) {
        var accountList = dependency.accountListSubject.value
        accountList.remove(at: index)
        dependency.accountListSubject.send(accountList)
    }
    
    func accountCreated(_ account: Account) {
        let accountList = dependency.accountListSubject.value
        dependency.accountListSubject.send(accountList + [account])
    }
    
    func close() {
        router?.detachAccountRegister()
    }
}
