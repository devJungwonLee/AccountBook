//
//  RootBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import ModernRIBs

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency>, LoggedInDependency {
    private let rootViewController: RootViewController
    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
    
    init(dependency: RootDependency,
        rootViewController: RootViewController
    ) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        
        let component = RootComponent(dependency: dependency, rootViewController: viewController)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        
        return RootRouter(
            loggedInBuilder: loggedInBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
