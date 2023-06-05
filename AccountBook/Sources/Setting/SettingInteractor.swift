//
//  SettingInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs
import LocalAuthentication

protocol SettingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingPresentable: Presentable {
    var listener: SettingPresentableListener? { get set }
    func displaySwitch(with isOn: Bool)
    func hideAuthenticationNotice()
}

protocol SettingListener: AnyObject {
    func accountNumberHidingFlagChanged(_ shouldHide: Bool)
}

protocol SettingInteractorDependency {
    var localAuthenticationRepository: LocalAuthenticationRepositoryType { get }
}

final class SettingInteractor: PresentableInteractor<SettingPresentable>, SettingInteractable, SettingPresentableListener {
    weak var router: SettingRouting?
    weak var listener: SettingListener?
    private let dependency: SettingInteractorDependency
    
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
        get {
            return UserDefaults.standard.bool(forKey: "accountNumberHidingFlag")
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "accountNumberHidingFlag")
        }
    }
    
    func viewDidLoad() {
        presenter.displaySwitch(with: accountNumberHidingFlag)
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
                self?.presenter.displaySwitch(with: result)
                self?.listener?.accountNumberHidingFlagChanged(result)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
