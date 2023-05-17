//
//  BankSelectViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol BankSelectPresentableListener: AnyObject {
    func bankSelected(_ bank: Bank)
    func bankNameCreated(_ bankName: String)
    func didDisappear()
}

final class BankSelectViewController: UIViewController, BankSelectPresentable, BankSelectViewControllable {
    weak var listener: BankSelectPresentableListener?
    
    private var banks: [Bank] = []
    
    private let cellRegistration = UICollectionView.CellRegistration<BankCell, Bank> { cell, _, bank in
        cell.configure(with: bank)
    }
    
    private let footerViewRegistration = UICollectionView.SupplementaryRegistration<BankSelectFooterView>(
        elementKind: UICollectionView.elementKindSectionFooter
    ) { _, _, _ in }
    
    private lazy var collectionView = BankCollectionView().then {
        $0.dataSource = self
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func displayBankList(_ banks: [Bank]) {
        self.banks = banks
    }
}

private extension BankSelectViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "은행 선택"
    }
    
    func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BankSelectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bank = banks[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration, for: indexPath, item: bank
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueConfiguredReusableSupplementary(
            using: footerViewRegistration, for: indexPath
        )
        footerView.delegate = self
        return footerView
    }
}

extension BankSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.backgroundColor = .secondarySystemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.bankSelected(banks[indexPath.item])
    }
}

extension BankSelectViewController: InputButtonDelegate, AlertPresentable {
    func inputButtonTapped() {
        presentTextFieldAlert(title: "은행이름 입력", message: "최대 20자까지 입력하실 수 있습니다.") { [weak self] bankName in
            self?.listener?.bankNameCreated(bankName)
        }
    }
}
