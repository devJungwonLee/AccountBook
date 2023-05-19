//
//  AccountRegisterViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import UIKit
import Combine
import SnapKit
import Then

protocol AccountRegisterPresentableListener: AnyObject {
    var bankNameStream: AnyPublisher<String, Never> { get }
    var accountNumberStream: AnyPublisher<String, Never> { get }
    var accountNumberErrorStream: AnyPublisher<Bool, Never> { get }
    var accountNameStream: AnyPublisher<String, Never> { get }
    var accountNameErrorStream: AnyPublisher<Bool, Never> { get }
    var inputValidationStream: AnyPublisher<Bool, Never> { get }
    func didDisappear()
    func bankSelectInputTapped()
    func accountNumberChanged(_ text: String)
    func accountNameChanged(_ text: String)
}

final class AccountRegisterViewController: UIViewController, AccountRegisterPresentable, AccountRegisterViewControllable, KeyboardObservable {
    weak var listener: AccountRegisterPresentableListener?
    private var cancellables = Set<AnyCancellable>()
    
    lazy var scrollView = UIScrollView().then {
        $0.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(scrollViewTapped)
            )
        )
    }
    
    private let contentView = UIView()
    
    private let bankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "은행"
    }
    
    private lazy var bankSelectInputView = BankSelectInputView().then {
        $0.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(bankSelectInputViewTapped)
            )
        )
    }
    
    private let accountNumberLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌번호"
    }
    
    private let accountNumberErrorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "16자 이내"
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    private lazy var accountNumberTextField = UnderLineTextField().then {
        $0.keyboardType = .numberPad
        $0.placeholder = "계좌번호 입력"
        $0.inputAccessoryView = accessoryDoneButton
        $0.addTarget(self, action: #selector(accountNumberChanged), for: .editingChanged)
    }
    
    private let accountNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌이름"
    }
    
    private let accountNameErrorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "20자 이내"
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    private lazy var accountNameTextField = UnderLineTextField().then {
        $0.placeholder = "계좌이름 입력"
        $0.inputAccessoryView = accessoryDoneButton
        $0.addTarget(self, action: #selector(accountNameChanged), for: .editingChanged)
    }
    
    private lazy var accessoryDoneButton = UIButton(configuration: .filled()).then {
        var attributedString = AttributedString("등록")
        attributedString.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.background.cornerRadius = 0
        $0.isEnabled = false
        // $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private lazy var doneButton = UIButton(configuration: .filled()).then {
        var attributedString = AttributedString("등록")
        attributedString.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.cornerStyle = .large
        $0.isEnabled = false
        // $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        bindUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    func present(viewController: ViewControllable) {
        let navigationController = UINavigationController(
            rootViewController: viewController.uiviewController
        )
        present(navigationController, animated: true)
    }
}

private extension AccountRegisterViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "계좌 등록"
        addKeyboardObserver()
    }
    
    func configureLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        contentView.addSubview(bankLabel)
        bankLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }

        contentView.addSubview(bankSelectInputView)
        bankSelectInputView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(bankLabel.snp.bottom).offset(12)
        }

        contentView.addSubview(accountNumberLabel)
        accountNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(bankSelectInputView.snp.bottom).offset(32)
        }
        
        contentView.addSubview(accountNumberErrorLabel)
        accountNumberErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(accountNumberLabel.snp.trailing).offset(16)
            make.centerY.equalTo(accountNumberLabel.snp.centerY)
        }

        contentView.addSubview(accountNumberTextField)
        accountNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(accountNumberLabel.snp.bottom).offset(12)
        }

        contentView.addSubview(accountNameLabel)
        accountNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(accountNumberTextField.snp.bottom).offset(38)
        }
        
        contentView.addSubview(accountNameErrorLabel)
        accountNameErrorLabel.snp.makeConstraints { make in
            make.leading.equalTo(accountNameLabel.snp.trailing).offset(16)
            make.centerY.equalTo(accountNameLabel.snp.centerY)
        }

        contentView.addSubview(accountNameTextField)
        accountNameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(accountNameLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(34)
        }

        accessoryDoneButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(scrollView.snp.bottom).offset(20)
            make.height.equalTo(60)
        }
    }
    
    func bindUI() {
        listener?.bankNameStream
            .sink { [weak self] name in
                self?.bankSelectInputView.configure(name)
            }
            .store(in: &cancellables)
        
        listener?.accountNumberStream
            .sink { [weak self] accountNumber in
                self?.accountNumberTextField.text = accountNumber
            }
            .store(in: &cancellables)
        
        listener?.accountNumberErrorStream
            .sink { [weak self] isError in
                self?.accountNumberErrorLabel.isHidden = !isError
                self?.accountNumberTextField.configureUnderLine(isError)
            }
            .store(in: &cancellables)
        
        listener?.accountNameStream
            .sink { [weak self] accountName in
                self?.accountNameTextField.text = accountName
            }
            .store(in: &cancellables)
        
        listener?.accountNameErrorStream
            .sink { [weak self] isError in
                self?.accountNameErrorLabel.isHidden = !isError
                self?.accountNameTextField.configureUnderLine(isError)
            }
            .store(in: &cancellables)
        
        listener?.inputValidationStream
            .sink { [weak self] isValid in
                self?.doneButton.isEnabled = isValid
                self?.accessoryDoneButton.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
    
    @objc func scrollViewTapped() {
        view.endEditing(true)
    }
    
    @objc func bankSelectInputViewTapped() {
        view.endEditing(true)
        listener?.bankSelectInputTapped()
    }
    
    @objc func accountNumberChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        listener?.accountNumberChanged(text)
    }
    
    @objc func accountNameChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        listener?.accountNameChanged(text)
    }
}
