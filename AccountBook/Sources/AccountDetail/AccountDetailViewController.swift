//
//  AccountDetailViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/25.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol AccountDetailPresentableListener: AnyObject {
    func viewDidLoad()
    func didDisappear()
}

final class AccountDetailViewController: UIViewController, AccountDetailPresentable, AccountDetailViewControllable {
    weak var listener: AccountDetailPresentableListener?
    
    private let popUpView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .systemBackground
    }
    
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
    
    private let numberButton = UIButton(configuration: .plain())
    
    private lazy var bankStackview = UIStackView(arrangedSubviews: [
        logoImageView, nameLabel, numberButton
    ]).then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.alignment = .center
    }
    
    private let editButton = UIButton(configuration: .tinted()).then {
        $0.configuration?.attributedTitle = AttributedString("수정")
        $0.configuration?.cornerStyle = .large
    }
    
    private let deleteButton = UIButton(configuration: .tinted()).then {
        $0.configuration?.attributedTitle = AttributedString("삭제")
        $0.configuration?.cornerStyle = .large
        $0.configuration?.baseForegroundColor = .systemRed
        $0.configuration?.baseBackgroundColor = .systemRed
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        editButton, deleteButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        listener?.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    func displayAccount(_ account: Account) {
        let imageName = account.bank.code.isEmpty ? "placeholder" : account.bank.code
        logoImageView.image = UIImage(named: imageName)
        nameLabel.text = account.name
        numberButton.configuration?.attributedTitle = AttributedString(account.number)
        numberButton.configuration?.attributedTitle?.underlineStyle = .init(rawValue: 1)
    }
}

private extension AccountDetailViewController {
    func configureAttributes() {
        view.backgroundColor = .init(rgb: 0x000000, alpha: 0.2)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped)))
    }
    
    func configureLayout() {
        view.addSubview(popUpView)
        popUpView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(400)
            make.centerX.centerY.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        popUpView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        
        popUpView.addSubview(bankStackview)
        bankStackview.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-34)
        }
    }
    
    @objc func backgroundTapped(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: view)
        guard !popUpView.frame.contains(point) else { return }
        dismiss(animated: true)
    }
}
