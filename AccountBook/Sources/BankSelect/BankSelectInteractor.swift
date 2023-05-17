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
    func displayBankList(_ banks: [Bank])
}

protocol BankSelectListener: AnyObject {
    func bankDecided(_ bank: Bank)
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
    
    func bankSelected(_ bank: Bank) {
        bankDecided(bank)
    }
    
    func bankNameCreated(_ bankName: String) {
        let bank = Bank(code: "", name: bankName)
        bankDecided(bank)
    }
    
    func didDisappear() {
        listener?.close()
    }
    
    private func fetchBankList() {
        guard let url = Bundle.main.url(forResource: "BankList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let banks = try? JSONDecoder().decode([Bank].self, from: data) else { return }
        presenter.displayBankList(banks)
    }
    
    private func bankDecided(_ bank: Bank) {
        listener?.bankDecided(bank)
        router?.dismiss()
    }
}
