//
//  RootBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import ModernRIBs

protocol RootDependency: Dependency {
    var bankAssetRepository: BankAssetRepositoryType { get }
}

final class RootComponent:
    Component<RootDependency>,
    LoggedInDependency,
    RootInteractorDependency
{
    private let rootViewController: RootViewController

    var bankAssetRepository: BankAssetRepositoryType {
        dependency.bankAssetRepository
    }
    
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
        let component = RootComponent(dependency: dependency, rootViewController: viewController)
        let interactor = RootInteractor(presenter: viewController, dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)
        
        return RootRouter(
            loggedInBuilder: loggedInBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
