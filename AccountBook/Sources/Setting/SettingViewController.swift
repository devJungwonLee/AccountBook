//
//  SettingViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol SettingPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class SettingViewController: UIViewController, SettingPresentable, SettingViewControllable {
    weak var listener: SettingPresentableListener?
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingCellState>?
    private let cellRegistration = UICollectionView.CellRegistration<SettingCell, SettingCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: listLayout()
    ).then {
        $0.backgroundColor = .systemBackground
        $0.alwaysBounceVertical = false
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        configureDiffableDataSource()
        displayAccountList()
    }
    
    func displayAccountList() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SettingCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems([.init(title: "계좌번호 가리기", isOn: false)])
        dataSource?.apply(snapshot)
    }
}

private extension SettingViewController {
    func configureTabBarItem() {
        tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
    }
    
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "설정"
    }
    
    func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func listLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, SettingCellState>(collectionView: collectionView) { [weak self] collectionView, indexPath, setting in
            guard let self else { return  nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: setting)
            return cell
        }
    }
}
