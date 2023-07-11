//
//  BackupRecoveryViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol BackupRecoveryPresentableListener: AnyObject {
    func didDisappear()
}

final class BackupRecoveryViewController: UIViewController, BackupRecoveryPresentable, BackupRecoveryViewControllable {
    weak var listener: BackupRecoveryPresentableListener?
    
    private let noticeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .systemGray
        $0.numberOfLines = 0
        $0.text = "iCloud를 이용하여 계좌 목록을 백업하고, 같은 iCloud 계정으로 로그인된 기기에서 복구할 수 있습니다."
    }
    
    private let backupInfoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = "마지막으로 133개의 계좌가 백업되었습니다."
    }
    
    private let backupDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.text = "2023년 7월 10일 월요일 오후 5:49"
    }
    
    private lazy var backupInfoStackView = UIStackView(arrangedSubviews: [
        backupInfoLabel, backupDateLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var backupButton = UIButton(configuration: .bordered()).then {
        var attributedString = AttributedString("백업")
        attributedString.font = .systemFont(ofSize: 20, weight: .medium)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.image = UIImage(systemName: "icloud.and.arrow.up", withConfiguration: imageConfiguration)
        $0.configuration?.imagePadding = 12
        $0.configuration?.imagePlacement = .top
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.cornerStyle = .medium
        $0.addTarget(self, action: #selector(backupButtonTapped), for: .touchUpInside)
    }
    
    private lazy var recoveryButton = UIButton(configuration: .bordered()).then {
        var attributedString = AttributedString("복구")
        attributedString.font = .systemFont(ofSize: 20, weight: .medium)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 24)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.image = UIImage(systemName: "icloud.and.arrow.down", withConfiguration: imageConfiguration)
        $0.configuration?.imagePadding = 12
        $0.configuration?.imagePlacement = .top
        $0.configuration?.baseForegroundColor = .label
        $0.configuration?.cornerStyle = .medium
        $0.addTarget(self, action: #selector(recoveryButtonTapped), for: .touchUpInside)
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        backupButton, recoveryButton
    ]).then {
        $0.axis = .vertical
        $0.spacing = 40
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
}

private extension BackupRecoveryViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "데이터 백업 및 복구"
    }
    
    func configureLayout() {
        view.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(backupInfoStackView)
        backupInfoStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        backupButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(120)
        }
        
        recoveryButton.snp.makeConstraints { make in
            make.width.equalTo(180)
            make.height.equalTo(120)
        }
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    @objc func backupButtonTapped() {
        
    }
    
    @objc func recoveryButtonTapped() {
        
    }
}
