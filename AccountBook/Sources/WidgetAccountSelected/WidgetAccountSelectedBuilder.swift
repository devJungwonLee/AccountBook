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
    var id: String
    
    init(dependency: WidgetAccountSelectedDependency, id: String) {
        self.id = id
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol WidgetAccountSelectedBuildable: Buildable {
    func build(withListener listener: WidgetAccountSelectedListener, id: String) -> WidgetAccountSelectedRouting
}

final class WidgetAccountSelectedBuilder: Builder<WidgetAccountSelectedDependency>, WidgetAccountSelectedBuildable {

    override init(dependency: WidgetAccountSelectedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: WidgetAccountSelectedListener, id: String) -> WidgetAccountSelectedRouting {
        let component = WidgetAccountSelectedComponent(dependency: dependency, id: id)
        let viewController = WidgetAccountSelectedViewController()
        let interactor = WidgetAccountSelectedInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return WidgetAccountSelectedRouter(interactor: interactor, viewController: viewController)
    }
}
