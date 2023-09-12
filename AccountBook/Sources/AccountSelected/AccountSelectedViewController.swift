//
//  AccountSelectedViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol AccountSelectedPresentableListener: AnyObject {
    func viewDidLoad()
    func doneButtonTapped()
    func didDisappear()
}

final class AccountSelectedViewController: UIViewController, AccountSelectedPresentable, AccountSelectedViewControllable {
    weak var listener: AccountSelectedPresentableListener?
    
    private let logoImageView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 0
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌번호가 복사되었습니다."
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        logoImageView, nameLabel, titleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
    }
    
    private lazy var doneButton = UIButton(configuration: .filled()).then {
        var attributedString = AttributedString("확인")
        attributedString.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.cornerStyle = .large
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        listener?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            listener?.didDisappear()
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func displayNotice(_ account: Account, _ copyText: String) {
        logoImageView.image = UIImage(named: account.bank.code)
        nameLabel.text = account.name + "의"
        UIPasteboard.general.string = copyText
    }
}

private extension AccountSelectedViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
    @objc func doneButtonTapped() {
        listener?.doneButtonTapped()
    }
}
