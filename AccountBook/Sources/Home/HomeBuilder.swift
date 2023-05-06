//
//  HomeBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol HomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class HomeComponent: Component<HomeDependency>, AccountRegisterDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let viewController = HomeViewController()
        let interactor = HomeInteractor(presenter: viewController)
        
        let component = HomeComponent(dependency: dependency)
        let accountRegisterBuilder = AccountRegisterBuilder(dependency: component)
        
        interactor.listener = listener
        return HomeRouter(
            accountRegisterBuilder: accountRegisterBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
