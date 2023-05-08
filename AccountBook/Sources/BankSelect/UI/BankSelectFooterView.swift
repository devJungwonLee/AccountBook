//
//  BankSelectFooterView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/08.
//

import UIKit
import SnapKit
import Then

final class BankSelectFooterView: UICollectionReusableView {
    private let inputButton = UIButton(configuration: .plain()).then {
        var attributedString = AttributedString("직접 입력")
        attributedString.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseForegroundColor = .main
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BankSelectFooterView {
    func configureAttributes() {
        backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        addSubview(inputButton)
        inputButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(28)
        }
    }
}
