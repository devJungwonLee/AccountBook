//
//  BankSelectInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import Foundation
import ModernRIBs
import Combine

protocol BankSelectRouting: ViewableRouting {
    func close()
}

protocol BankSelectPresentable: Presentable {
    var listener: BankSelectPresentableListener? { get set }
    func displayBankList(_ banks: [Bank])
}

protocol BankSelectListener: AnyObject {
    func bankDecided(_ bank: Bank)
    func close()
}

protocol BankSelectInteractorDependency {
    var banks: CurrentValueSubject<[Bank], Never> { get }
}

final class BankSelectInteractor: PresentableInteractor<BankSelectPresentable>, BankSelectInteractable, BankSelectPresentableListener {
    weak var router: BankSelectRouting?
    weak var listener: BankSelectListener?
    
    private let dependency: BankSelectInteractorDependency
    private var cancellables = Set<AnyCancellable>()
    
    init(
        presenter: BankSelectPresentable,
        dependency: BankSelectInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func viewDidLoad() {
        fetchBankList()
    }
    
    func bankSelected(_ index: Int) {
        let bank = dependency.banks.value[index]
        bankDecided(bank)
    }
    
    func bankNameCreated(_ bankName: String) {
        let bank = Bank(code: "", name: bankName)
        bankDecided(bank)
    }
    
    func didDisappear() {
        listener?.close()
    }
    
    private func bind() {
        dependency.banks
            .sink { [weak self] banks in
                self?.presenter.displayBankList(banks)
            }
            .store(in: &cancellables)
    }
    
    private func fetchBankList() {
        guard let url = Bundle.main.url(forResource: "BankList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let banks = try? JSONDecoder().decode([Bank].self, from: data) else { return }
        dependency.banks.send(banks)
    }
    
    private func bankDecided(_ bank: Bank) {
        listener?.bankDecided(bank)
        router?.close()
    }
}
