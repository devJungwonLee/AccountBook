//
//  MainInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import Foundation
import Combine

protocol MainRouting: ViewableRouting {
    func attachChildren()
    func attachWidgetAccountSelected(id: String)
    func detachWidgetAccountSelected()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
    var accountNumberHidingFlagSubject: CurrentValueSubject<Bool?, Never> { get }
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {
    weak var router: MainRouting?
    weak var listener: MainListener?
    private let dependency: MainInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MainPresentable, dependency: MainInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachChildren()
        addObserver()
    }

    override func willResignActive() {
        super.willResignActive()
        removeObserver()
    }
    
    func accountNumberHidingFlagChanged(_ shouldHide: Bool) {
        dependency.accountNumberHidingFlagSubject.send(shouldHide)
    }
    
    func closeWidgetAccountSelected() {
        router?.detachWidgetAccountSelected()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: .copyAccountNumber, object: nil, queue: .main
        ) { [weak self] notification in
            guard let url = notification.object as? URL else { return }
            let id = url.absoluteString
            self?.router?.attachWidgetAccountSelected(id: id)
        }
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
