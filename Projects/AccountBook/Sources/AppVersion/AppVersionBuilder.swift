//
//  AppVersionBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs

protocol AppVersionDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppVersionComponent: Component<AppVersionDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppVersionBuildable: Buildable {
    func build(withListener listener: AppVersionListener) -> AppVersionRouting
}

final class AppVersionBuilder: Builder<AppVersionDependency>, AppVersionBuildable {

    override init(dependency: AppVersionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppVersionListener) -> AppVersionRouting {
        _ = AppVersionComponent(dependency: dependency)
        let viewController = AppVersionViewController()
        let interactor = AppVersionInteractor(presenter: viewController)
        interactor.listener = listener
        return AppVersionRouter(interactor: interactor, viewController: viewController)
    }
}
