//
//  HomeViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import UIKit
import Combine
import SnapKit
import Then

protocol HomePresentableListener: AnyObject {
    var accountListStream: AnyPublisher<[Account], Never> { get }
    func addButtonTapped()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    weak var listener: HomePresentableListener?
    private var cancellables = Set<AnyCancellable>()
    
    
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, MyAccountCellState>?
    private let cellRegistration = UICollectionView.CellRegistration<MyAccountCell, MyAccountCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }

    
    private lazy var collectionView = MyAccountCollectionView()
    
    private let homeEmptyView = HomeEmptyView()
    
    
    private lazy var addButton = UIButton(configuration: .filled()).then {
        $0.configuration?.image = UIImage(systemName: "plus")
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.background.cornerRadius = 30
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
        bind()
    }
    
    func push(viewController: ViewControllable) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(
            viewController.uiviewController,
            animated: true
        )
    }
}

private extension HomeViewController {
    func configureTabBarItem() {
        tabBarItem = UITabBarItem(
            title: "내 계좌",
            image: UIImage(systemName: "list.bullet.rectangle"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
    }
    
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "내 계좌"
    }
    
    func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(homeEmptyView)
        homeEmptyView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, MyAccountCellState>(collectionView: collectionView) { [weak self] collectionView, indexPath, account in
            guard let self else { return  nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: account)
            return cell
        }
    }
    
    func bind() {
        listener?.accountListStream
            .sink { [weak self] accounts in
                self?.homeEmptyView.isHidden = !accounts.isEmpty
                self?.collectionView.isHidden = accounts.isEmpty
                if !accounts.isEmpty { self?.displayAccountList(accounts) }
            }
            .store(in: &cancellables)
    }
    
    func displayAccountList(_ accounts: [Account]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MyAccountCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems(accounts.map { MyAccountCellState($0) })
        dataSource?.apply(snapshot)
    }
    
    @objc func addButtonTapped() {
        listener?.addButtonTapped()
    }
}
