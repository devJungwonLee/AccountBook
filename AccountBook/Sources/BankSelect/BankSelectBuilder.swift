//
//  BankSelectBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import ModernRIBs

protocol BankSelectDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class BankSelectComponent: Component<BankSelectDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol BankSelectBuildable: Buildable {
    func build(withListener listener: BankSelectListener) -> BankSelectRouting
}

final class BankSelectBuilder: Builder<BankSelectDependency>, BankSelectBuildable {

    override init(dependency: BankSelectDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BankSelectListener) -> BankSelectRouting {
        _ = BankSelectComponent(dependency: dependency)
        let viewController = BankSelectViewController()
        let interactor = BankSelectInteractor(presenter: viewController)
        interactor.listener = listener
        return BankSelectRouter(interactor: interactor, viewController: viewController)
    }
}
