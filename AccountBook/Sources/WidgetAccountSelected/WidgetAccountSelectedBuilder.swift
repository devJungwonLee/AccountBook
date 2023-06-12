//
//  WidgetAccountSelectedBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs

protocol WidgetAccountSelectedDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class WidgetAccountSelectedComponent:
    Component<WidgetAccountSelectedDependency>,
    WidgetAccountSelectedInteractorDependency
{
    var account: Account
    
    init(dependency: WidgetAccountSelectedDependency, account: Account) {
        self.account = account
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol WidgetAccountSelectedBuildable: Buildable {
    func build(withListener listener: WidgetAccountSelectedListener, account: Account) -> WidgetAccountSelectedRouting
}

final class WidgetAccountSelectedBuilder: Builder<WidgetAccountSelectedDependency>, WidgetAccountSelectedBuildable {

    override init(dependency: WidgetAccountSelectedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WidgetAccountSelectedListener, account: Account) -> WidgetAccountSelectedRouting {
        let component = WidgetAccountSelectedComponent(dependency: dependency, account: account)
        let viewController = WidgetAccountSelectedViewController()
        let interactor = WidgetAccountSelectedInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return WidgetAccountSelectedRouter(interactor: interactor, viewController: viewController)
    }
}
