//
//  OpenSourceLicenseBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import ModernRIBs

protocol OpenSourceLicenseDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OpenSourceLicenseComponent: Component<OpenSourceLicenseDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OpenSourceLicenseBuildable: Buildable {
    func build(withListener listener: OpenSourceLicenseListener) -> OpenSourceLicenseRouting
}

final class OpenSourceLicenseBuilder: Builder<OpenSourceLicenseDependency>, OpenSourceLicenseBuildable {

    override init(dependency: OpenSourceLicenseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OpenSourceLicenseListener) -> OpenSourceLicenseRouting {
        _ = OpenSourceLicenseComponent(dependency: dependency)
        let viewController = OpenSourceLicenseViewController()
        let interactor = OpenSourceLicenseInteractor(presenter: viewController)
        interactor.listener = listener
        return OpenSourceLicenseRouter(interactor: interactor, viewController: viewController)
    }
}
