//
//  AuthenticationNoticeView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/01.
//

import UIKit

final class AuthenticationNoticeView: UIView {
    private let toucIDImageView = UIImageView(image: UIImage(systemName: "touchid")).then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .main
    }
    private let faceIDImageView = UIImageView(image: UIImage(systemName: "faceid")).then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .main
    }
    
    private let authenticationLabel = UILabel().then {
        $0.text = "생체인증을 진행합니다"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    private lazy var iconStackView = UIStackView(arrangedSubviews: [
        toucIDImageView, faceIDImageView
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        iconStackView, authenticationLabel
    ]).then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthenticationNoticeView {
    func configureAttributes() {
        backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        toucIDImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        faceIDImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        addSubview(noticeStackView)
        noticeStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
