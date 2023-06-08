//
//  WidgetAccountSelectedInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs

protocol WidgetAccountSelectedRouting: ViewableRouting {
    func close()
}

protocol WidgetAccountSelectedPresentable: Presentable {
    var listener: WidgetAccountSelectedPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol WidgetAccountSelectedListener: AnyObject {
    func closeWidgetAccountSelected()
}

protocol WidgetAccountSelectedInteractorDependency {
    var id: String { get }
}

final class WidgetAccountSelectedInteractor: PresentableInteractor<WidgetAccountSelectedPresentable>, WidgetAccountSelectedInteractable, WidgetAccountSelectedPresentableListener {

    weak var router: WidgetAccountSelectedRouting?
    weak var listener: WidgetAccountSelectedListener?
    private let dependency: WidgetAccountSelectedInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: WidgetAccountSelectedPresentable,
        dependency: WidgetAccountSelectedInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func doneButtonTapped() {
        router?.close()
    }
    
    func didDisappear() {
        listener?.closeWidgetAccountSelected()
    }
}
