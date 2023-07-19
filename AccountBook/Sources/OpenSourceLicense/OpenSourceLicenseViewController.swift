//
//  OpenSourceLicenseViewController.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import ModernRIBs
import UIKit

enum OpenSourceSection {
    case frameWork, license
}

enum OpenSourceItem: Hashable {
    case frameWorkItem(FrameworkCellState), licenseItem(LicenseCellState)
}

protocol OpenSourceLicensePresentableListener: AnyObject {
    func viewDidLoad()
    func didDisappear()
}

final class OpenSourceLicenseViewController: UIViewController, OpenSourceLicensePresentable, OpenSourceLicenseViewControllable {
    weak var listener: OpenSourceLicensePresentableListener?
    private var dataSource: UICollectionViewDiffableDataSource<OpenSourceSection, OpenSourceItem>?
    private let frameworkCellRegistration = UICollectionView.CellRegistration<FrameworkCell, FrameworkCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private let licenseCellRegistration = UICollectionView.CellRegistration<LicenseCell, LicenseCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: listLayout()
    ).then {
        $0.backgroundColor = .systemBackground
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
    
    func displayOpenSourceInfo(frameworks: [Framework], licenses: [License]) {
        let frameworkItems: [OpenSourceItem] = frameworks.map {
            .frameWorkItem(FrameworkCellState($0))
        }
        let licenseItems: [OpenSourceItem] = licenses.map {
            .licenseItem(LicenseCellState($0))
        }
        var snapshot = NSDiffableDataSourceSnapshot<OpenSourceSection, OpenSourceItem>()
        snapshot.appendSections([.frameWork, .license])
        snapshot.appendItems(frameworkItems, toSection: .frameWork)
        snapshot.appendItems(licenseItems, toSection: .license)
        dataSource?.apply(snapshot)
    }
}

private extension OpenSourceLicenseViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "오픈소스 라이선스"
    }
    
    func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func listLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<OpenSourceSection, OpenSourceItem>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return nil }
            switch item {
            case .frameWorkItem(let cellState):
                let cell = collectionView.dequeueConfiguredReusableCell(using: frameworkCellRegistration, for: indexPath, item: cellState)
                return cell
            case .licenseItem(let cellState):
                let cell = collectionView.dequeueConfiguredReusableCell(using: licenseCellRegistration, for: indexPath, item: cellState)
                return cell
            }
        }
    }
}
