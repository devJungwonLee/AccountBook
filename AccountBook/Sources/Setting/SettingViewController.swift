//
//  SettingViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs
import UIKit
import Combine
import SnapKit
import Then

protocol SettingPresentableListener: AnyObject {
    var menuListStream: AnyPublisher<[SettingMenu], Never> { get }
    func viewDidLoad()
    func switchTapped(_ isOn: Bool)
    func didSelectItemAt(_ index: Int)
}

final class SettingViewController:
    UIViewController,
    SettingPresentable,
    SettingViewControllable,
    SafariPresentable,
    URLRoutable,
    ActivityViewPresentable
{
    weak var listener: SettingPresentableListener?
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingCellState>?
    private let cellRegistration = UICollectionView.CellRegistration<SettingCell, SettingCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: listLayout()
    ).then {
        $0.backgroundColor = .systemBackground
        $0.delegate = self
    }
    
    private let authenticationNoticeView = AuthenticationNoticeView().then {
        $0.isHidden = true
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
        listener?.viewDidLoad()
    }
    
    func push(viewController: ViewControllable) {
        viewController.uiviewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
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
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        view.addSubview(authenticationNoticeView)
        authenticationNoticeView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func listLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, SettingCellState>(collectionView: collectionView) { [weak self] collectionView, indexPath, setting in
            guard let self else { return nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: setting)
            cell.delegate = self
            return cell
        }
    }
    
    func bind() {
        listener?.menuListStream
            .sink { [weak self] menuList in
                self?.displayMenuList(menuList)
            }
            .store(in: &cancellables)
    }
    
    func displayMenuList(_ menuList: [SettingMenu]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SettingCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems(menuList.map { .init($0) })
        dataSource?.apply(snapshot)
        collectionView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.authenticationNoticeView.isHidden = true
        }
    }
}

extension SettingViewController: SettingCellDelegate {
    func switchTapped(_ isOn: Bool) {
        collectionView.isHidden = true
        authenticationNoticeView.isHidden = false
        listener?.switchTapped(isOn)
    }
}

extension SettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let cellState = dataSource?.itemIdentifier(for: indexPath) else { return false }
        return cellState.isOn == nil ? true : false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cellState = dataSource?.itemIdentifier(for: indexPath) else { return false }
        return cellState.isOn == nil ? true : false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.didSelectItemAt(indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
