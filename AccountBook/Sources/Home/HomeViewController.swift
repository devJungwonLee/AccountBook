//
//  HomeViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

struct Account {
    let name: String
    let number: String
}

protocol HomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    weak var listener: HomePresentableListener?
    
    private var accounts: [Account] = [
        .init(name: "신한은행 계좌", number: "123456789012"),
        .init(name: "우리은행 계좌", number: "123456789012"),
        .init(name: "카카오뱅크 계좌", number: "123456789012"),
        .init(name: "토스뱅크 계좌", number: "123456789012"),
        .init(name: "스탠다드차타드은행 계좌", number: "123456789012"),
        .init(name: "신한은행 계좌", number: "123456789012"),
        .init(name: "우리은행 계좌", number: "123456789012"),
        .init(name: "카카오뱅크 계좌", number: "123456789012"),
        .init(name: "토스뱅크 계좌", number: "123456789012"),
        .init(name: "스탠다드차타드은행 계좌", number: "123456789012")
    ]
    
    private let homeEmptyView = HomeEmptyView()
    
    private let cellRegistration = UICollectionView.CellRegistration<MyAccountCell, Account> { cell, _, account in
        cell.configure(with: account)
    }
    
    private lazy var collectionView = MyAccountCollectionView().then {
        $0.dataSource = self
    }
    
    private lazy var addButton = UIButton(configuration: .filled()).then {
        $0.configuration?.image = UIImage(systemName: "plus")
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.background.cornerRadius = 30
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
        homeEmptyView.isHidden = !accounts.isEmpty
        collectionView.isHidden = accounts.isEmpty
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
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let account = accounts[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration, for: indexPath, item: account
        )
        return cell
    }
}
