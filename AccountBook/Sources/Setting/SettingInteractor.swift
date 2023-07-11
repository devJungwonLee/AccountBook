//
//  SettingInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs
import Combine
import LocalAuthentication

protocol SettingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
}

protocol SettingListener: AnyObject {
    func accountNumberHidingFlagChanged(_ shouldHide: Bool)
    func accountsDownloaded()
}

protocol SettingInteractorDependency {
    var menuListSubject: PassthroughSubject<[SettingMenu], Never> { get }
    var localAuthenticationRepository: LocalAuthenticationRepositoryType { get }
    var accountRepository: AccountRepositoryType { get }
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>, SettingInteractable, SettingPresentableListener {
    weak var router: SettingRouting?
    weak var listener: SettingListener?
    private let dependency: SettingInteractorDependency
    private var standard: UserDefaults { UserDefaults.standard }
    
    var menuListStream: AnyPublisher<[SettingMenu], Never> {
        return dependency.menuListSubject.eraseToAnyPublisher()
    }
    
    init(presenter: SettingPresentable, dependency: SettingInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        listener?.accountNumberHidingFlagChanged(accountNumberHidingFlag)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    var accountNumberHidingFlag: Bool {
        get { standard.bool(forKey: UserDefaultsKey.accountNumberHidingFlag) }
        set(newValue) { standard.setValue(newValue, forKey: UserDefaultsKey.accountNumberHidingFlag) }
    }
    
    private func configureMenuList(with isOn: Bool) {
        let menuList: [SettingMenu] = [
            .init(title: "계좌번호 가리기", isOn: isOn)
        ]
        dependency.menuListSubject.send(menuList)
    }
    
    func viewDidLoad() {
        configureMenuList(with: accountNumberHidingFlag)
    }
    
    func uploadButtonTapped() {
        dependency.accountRepository.uploadAccounts()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: {
                
            }
            .cancelOnDeactivate(interactor: self)

    }
    
    func downloadButtonTapped() {
        dependency.accountRepository.downloadAccounts()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.listener?.accountsDownloaded()
            }
            .cancelOnDeactivate(interactor: self)
    }
    
    func switchTapped(_ isOn: Bool) {
        dependency
            .localAuthenticationRepository
            .authenticate(localizedReason: "계좌번호 숨김 설정을 위해 인증을 진행합니다.")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] isSuccess in
                let result = isSuccess ? isOn : !isOn
                self?.accountNumberHidingFlag = result
                self?.listener?.accountNumberHidingFlagChanged(result)
                self?.configureMenuList(with: result)
                if isOn { UserDefaults.standard.removeObject(forKey: UserDefaultsKey.lastUnlockTime) }
            }
            .cancelOnDeactivate(interactor: self)
    }
}
