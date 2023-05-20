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
    func viewDidLoad()
    func bankSelected(_ index: Int)
    func bankNameCreated(_ bankName: String)
    func didDisappear()
}

final class BankSelectViewController: UIViewController, BankSelectPresentable, BankSelectViewControllable {
    weak var listener: BankSelectPresentableListener?
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, BankCellState>?
    private let cellRegistration = UICollectionView.CellRegistration<BankCell, BankCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private let footerViewRegistration = UICollectionView.SupplementaryRegistration<BankSelectFooterView>(
        elementKind: UICollectionView.elementKindSectionFooter
    ) { _, _, _ in }
    
    private lazy var collectionView = BankCollectionView().then {
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        configureDiffableDataSource()
        listener?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func displayBankList(_ banks: [Bank]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BankCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems(banks.map { BankCellState($0) })
        dataSource?.apply(snapshot)
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
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, BankCellState>(collectionView: collectionView) { [weak self] collectionView, indexPath, bank in
            guard let self else { return nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: bank)
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self,
                  kind == UICollectionView.elementKindSectionFooter else {
                return nil
            }
            let footerView = collectionView.dequeueConfiguredReusableSupplementary(
                using: self.footerViewRegistration, for: indexPath
            )
            footerView.delegate = self
            return footerView
        }
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
        listener?.bankSelected(indexPath.item)
    }
}

extension BankSelectViewController: InputButtonDelegate, AlertPresentable {
    func inputButtonTapped() {
        presentTextFieldAlert(title: "은행이름 입력", message: "최대 20자까지 입력하실 수 있습니다.") { [weak self] bankName in
            self?.listener?.bankNameCreated(bankName)
        }
    }
}
