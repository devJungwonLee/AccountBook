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
    func attachBackupRecovery()
    func detachBackupRecovery()
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
            .init(title: "계좌번호 가리기", isOn: isOn),
            .init(title: "데이터 백업 및 복구", isOn: nil),
            .init(title: "버그, 오류 제보", isOn: nil),
            .init(title: "평가, 리뷰 남기기", isOn: nil),
            .init(title: "오픈소스 라이선스", isOn: nil),
            .init(title: "개인정보 처리방침", isOn: nil),
            .init(title: "앱 공유하기", isOn: nil),
            .init(title: "앱 버전", isOn: nil)
        ]
        dependency.menuListSubject.send(menuList)
    }
    
    func viewDidLoad() {
        configureMenuList(with: accountNumberHidingFlag)
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
    
    func didSelectItemAt(_ index: Int) {
        if index == 1 {
            router?.attachBackupRecovery()
        }
    }
    
    func closeBackupRecovery() {
        router?.detachBackupRecovery()
    }
    
    func accountsDownloaded() {
        listener?.accountsDownloaded()
    }
}
