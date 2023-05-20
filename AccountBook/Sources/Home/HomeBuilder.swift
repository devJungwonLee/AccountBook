//
//  HomeBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol HomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class HomeComponent:
    Component<HomeDependency>,
    AccountRegisterDependency,
    HomeInteractorDependency {
    var accountListSubject: CurrentValueSubject<[Account], Never> = .init([])
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
        
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController, dependency: component)
        
        interactor.listener = listener
        return HomeRouter(
            accountRegisterBuilder: accountRegisterBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
