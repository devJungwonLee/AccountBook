//
//  AppVersionViewController.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol AppVersionPresentableListener: AnyObject {
    func didDisappear()
    func fetchAppVersion()
    func githubButtonTapped()
    func updateButtonTapped()
}

final class AppVersionViewController:
    UIViewController,
    AppVersionPresentable,
    AppVersionViewControllable,
    SafariPresentable,
    URLRoutable
{
    weak var listener: AppVersionPresentableListener?
    
    private let appIconImageView = UIImageView().then {
        $0.image = UIImage(named: "accountbook")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let appNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.text = "계좌번호부"
    }
    
    private let versionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .systemGray
    }
    
    private lazy var githubButton = UIButton().then {
        $0.setImage(UIImage(named: "github"), for: .normal)
        $0.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
    }
    
    private let developerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.text = "Made by Jungwon Lee"
    }
    
    private lazy var updateButton = UIButton(configuration: .filled()).then {
        var attributedString = AttributedString("버전 업데이트")
        attributedString.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.cornerStyle = .large
        $0.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
        listener?.fetchAppVersion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isMovingFromParent {
            listener?.didDisappear()
        }
    }
    
    func displayAppVersion(_ version: String) {
        versionLabel.text = "현재 버전 \(version)"
    }
}

private extension AppVersionViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        view.addSubview(updateButton)
        updateButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        
        view.addSubview(developerLabel)
        developerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(updateButton.snp.top).offset(-20)
        }
        
        view.addSubview(githubButton)
        githubButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(developerLabel.snp.top).offset(-8)
        }
        
        view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(114)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appNameLabel.snp.top).offset(-20)
        }
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appNameLabel.snp.bottom).offset(12)
        }
    }
    
    @objc func githubButtonTapped() {
        listener?.githubButtonTapped()
    }
    
    @objc func updateButtonTapped() {
        listener?.updateButtonTapped()
    }
}
