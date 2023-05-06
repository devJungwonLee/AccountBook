//
//  AccountRegisterViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol AccountRegisterPresentableListener: AnyObject {
    func didDisappear()
}

final class AccountRegisterViewController: UIViewController, AccountRegisterPresentable, AccountRegisterViewControllable {
    weak var listener: AccountRegisterPresentableListener?
    
    private let bankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "은행"
    }
    
    private let bankSelectInputView = BankSelectInputView()
    
    private let accountNumberLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌번호"
    }
    
    private let accountNumberTextField = UnderLineTextField().then {
        $0.keyboardType = .numberPad
        $0.placeholder = "계좌번호 입력"
    }
    
    private let accountNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌이름"
    }
    
    private let accountNameTextField = UnderLineTextField().then {
        $0.placeholder = "계좌이름 입력"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension AccountRegisterViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "계좌 등록"
    }
    
    func configureLayout() {
        view.addSubview(bankLabel)
        bankLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(bankSelectInputView)
        bankSelectInputView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(bankLabel.snp.bottom).offset(12)
        }
        
        view.addSubview(accountNumberLabel)
        accountNumberLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(bankSelectInputView.snp.bottom).offset(32)
        }
        
        view.addSubview(accountNumberTextField)
        accountNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(accountNumberLabel.snp.bottom).offset(12)
        }
        
        view.addSubview(accountNameLabel)
        accountNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(accountNumberTextField.snp.bottom).offset(38)
        }
        
        view.addSubview(accountNameTextField)
        accountNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(accountNameLabel.snp.bottom).offset(12)
        }
    }
}
