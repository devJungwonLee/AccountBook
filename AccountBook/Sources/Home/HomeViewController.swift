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
    var accountNumberHidingFlagStream: AnyPublisher<Bool, Never> { get }
    var copyTextStream: AnyPublisher<String, Never> { get }
    var accountListStream: AnyPublisher<[Account], Never> { get }
    func addButtonTapped()
    func trailingSwiped(_ index: Int)
    func copyButtonTapped(_ index: Int)
    func accountSelected(_ index: Int)
    func accountReordered(_ dates: [Date])
    func cancelButtonTapped()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable, ToastPresentable {
    weak var listener: HomePresentableListener?
    private var cancellables = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, AccountCellState>?
    private let cellRegistration = UICollectionView.CellRegistration<AccountCell, AccountCellState> { cell, _, cellState in
        cell.configure(with: cellState)
    }
    
    private lazy var collectionView = AccountCollectionView().then {
        $0.collectionViewLayout = listLayout()
        $0.delegate = self
    }
    
    private let homeEmptyView = HomeEmptyView()
    
    private lazy var addButton = UIButton(configuration: .filled()).then {
        $0.configuration?.image = UIImage(systemName: "plus")
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.background.cornerRadius = 30
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private lazy var cancelButton = UIBarButtonItem(
        title: "취소",
        style: .done,
        target: self,
        action: #selector(cancelButtonTapped)
    )
    
    private lazy var reorderButton = UIBarButtonItem(
        image: UIImage(systemName: "arrow.up.arrow.down.circle"),
        style: .plain,
        target: self,
        action: #selector(reorderButtonTapped)
    )
    
    private lazy var doneButton = UIBarButtonItem(
        title: "완료",
        style: .done,
        target: self,
        action: #selector(doneButtonTapped)
    )
    
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
    
    func present(viewController: ViewControllable) {
        viewController.uiviewController.modalTransitionStyle = .crossDissolve
        viewController.uiviewController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(viewController.uiviewController, animated: true)
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
        navigationItem.rightBarButtonItem = reorderButton
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
    
    func listLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let index = indexPath?.item else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, _ in
            self?.listener?.trailingSwiped(index)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, AccountCellState>(collectionView: collectionView) { [weak self] collectionView, indexPath, account in
            guard let self else { return  nil }
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: account)
            cell.delegate = self
            return cell
        }
        dataSource?.reorderingHandlers.canReorderItem = { _ in return true }
    }
    
    func bind() {
        if let accountListStream = listener?.accountListStream,
           let accountNumberHidingFlagStream = listener?.accountNumberHidingFlagStream {
            accountListStream.combineLatest(accountNumberHidingFlagStream)
                .sink { [weak self] (accounts, shouldHide) in
                    self?.homeEmptyView.isHidden = !accounts.isEmpty
                    self?.collectionView.isHidden = accounts.isEmpty
                    self?.navigationItem.rightBarButtonItem = accounts.isEmpty ? nil : self?.reorderButton
                    if !accounts.isEmpty { self?.displayAccountList(accounts, shouldHide: shouldHide) }
                }
                .store(in: &cancellables)
        }
        
        listener?.copyTextStream
            .sink { [weak self] copyText in
                UIPasteboard.general.string = copyText
                self?.showToast(message: "계좌번호 복사 완료")
            }
            .store(in: &cancellables)
    }
    
    func displayAccountList(_ accounts: [Account], shouldHide: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AccountCellState>()
        snapshot.appendSections([0])
        snapshot.appendItems(accounts.map { AccountCellState($0, shouldHide) })
        dataSource?.apply(snapshot)
    }
    
    @objc func addButtonTapped() {
        cancelButtonTapped()
        listener?.addButtonTapped()
    }
    
    @objc func reorderButtonTapped() {
        navigationItem.rightBarButtonItem = doneButton
        collectionView.isEditing = true
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func cancelButtonTapped() {
        listener?.cancelButtonTapped()
        navigationItem.rightBarButtonItem = reorderButton
        collectionView.isEditing = false
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func doneButtonTapped() {
        if let dates = dataSource?.snapshot().itemIdentifiers.map({ $0.date }) {
            listener?.accountReordered(dates)
        }
        navigationItem.rightBarButtonItem = reorderButton
        collectionView.isEditing = false
        navigationItem.leftBarButtonItem = nil
    }
}

extension HomeViewController: AccountCellDelegate {
    func copyButtonTapped(_ cell: AccountCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let index = indexPath.item
        listener?.copyButtonTapped(index)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.backgroundColor = .secondarySystemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.contentView.backgroundColor = .systemBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.accountSelected(indexPath.item)
    }
}
