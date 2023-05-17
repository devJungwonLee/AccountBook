//
//  BankSelectInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import Foundation
import ModernRIBs

protocol BankSelectRouting: ViewableRouting {
    func dismiss()
}

protocol BankSelectPresentable: Presentable {
    var listener: BankSelectPresentableListener? { get set }
    func presentBankList(_ banks: [Bank])
}

protocol BankSelectListener: AnyObject {
    func close()
}

final class BankSelectInteractor: PresentableInteractor<BankSelectPresentable>, BankSelectInteractable, BankSelectPresentableListener {

    weak var router: BankSelectRouting?
    weak var listener: BankSelectListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BankSelectPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchBankList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func bankNameCreated(_ bankName: String) {
        router?.dismiss()
    }
    
    func didDisappear() {
        listener?.close()
    }
    
    private func fetchBankList() {
        guard let url = Bundle.main.url(forResource: "BankList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let banks = try? JSONDecoder().decode([Bank].self, from: data) else { return }
        presenter.presentBankList(banks)
    }
}
