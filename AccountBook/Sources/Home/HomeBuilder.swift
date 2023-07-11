//
//  HomeBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol HomeDependency: Dependency {
    var accountNumberHidingFlagStream: AnyPublisher<Bool?, Never> { get }
    var accountsDownloadedEventStream: AnyPublisher<Void, Never> { get }
}

final class HomeComponent:
    Component<HomeDependency>,
    AccountRegisterDependency,
    AccountDetailDependency,
    HomeInteractorDependency {
    var copyTextSubject: PassthroughSubject<String, Never> = .init()
    var accountListSubject: CurrentValueSubject<[Account], Never> = .init([])
    var accountRepository: AccountRepositoryType = AccountRepository()
    var localAuthenticationRepository: LocalAuthenticationRepositoryType = LocalAuthenticationRepository()
    
    var accountNumberHidingFlagStream: AnyPublisher<Bool?, Never> {
        return dependency.accountNumberHidingFlagStream
    }
    
    var accountsDownloadedEventStream: AnyPublisher<Void, Never> {
        return dependency.accountsDownloadedEventStream
    }
}

// MARK: - Builder

protocol HomeBuildable: Buildable {
    func build(withListener listener: HomeListener) -> HomeRouting
}

final class HomeBuilder: Builder<HomeDependency>, HomeBuildable {

    override init(dependency: HomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: HomeListener) -> HomeRouting {
        let component = HomeComponent(dependency: dependency)
        let accountRegisterBuilder = AccountRegisterBuilder(dependency: component)
        let accountDetailBuilder = AccountDetailBuilder(dependency: component)
        
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController, dependency: component)
        
        interactor.listener = listener
        return HomeRouter(
            accountRegisterBuilder: accountRegisterBuilder,
            accountDetailBuilder: accountDetailBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
