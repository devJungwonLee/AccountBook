//
//  MainBuilder.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Combine

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent:
    Component<MainDependency>,
    HomeDependency,
    SettingDependency,
    AccountSelectedDependency,
    MainInteractorDependency
{
    var accountNumberHidingFlagSubject = CurrentValueSubject<Bool?, Never>(nil)
    var accountNumberHidingFlagStream: AnyPublisher<Bool?, Never> {
        return accountNumberHidingFlagSubject.eraseToAnyPublisher()
    }
    
    var accountRepository: AccountRepositoryType = MockRepository()
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
        let component = MainComponent(dependency: dependency)
        let homeBuilder = HomeBuilder(dependency: component)
        let settingBuilder = SettingBuilder(dependency: component)
        let accountSelectedBuilder = AccountSelectedBuilder(dependency: component)
        
        let viewController = MainViewController()
        let interactor = MainInteractor(presenter: viewController, dependency: component)
        
        interactor.listener = listener
        return MainRouter(
            homeBuilder: homeBuilder,
            settingBuilder: settingBuilder,
            accountSelectedBuilder: accountSelectedBuilder,
            interactor: interactor,
            viewController: viewController
        )
    }
}
