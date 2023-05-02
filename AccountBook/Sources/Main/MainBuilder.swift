//
//  MainBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency>, HomeDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> MainRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {
    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainListener) -> MainRouting {
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController)
        
        let component = MainComponent(dependency: dependency)
        let homeBuilder = HomeBuilder(dependency: component)
        
        interactor.listener = listener
        return MainRouter(
            homeBuilder: homeBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
