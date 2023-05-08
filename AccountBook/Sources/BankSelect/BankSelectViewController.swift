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
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BankSelectViewController: UIViewController, BankSelectPresentable, BankSelectViewControllable {
    weak var listener: BankSelectPresentableListener?
    
    private var banks: [Bank] = Bank.allCases
    
    private let cellRegistration = UICollectionView.CellRegistration<BankCell, Bank> { cell, _, bank in
        cell.configure(with: bank)
    }
    
    private let footerViewRegistration = UICollectionView.SupplementaryRegistration<BankSelectFooterView>(
        elementKind: UICollectionView.elementKindSectionFooter
    ) { _, _, _ in }
    
    private lazy var collectionView = BankCollectionView().then {
        $0.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
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
        return footerView
    }
}
