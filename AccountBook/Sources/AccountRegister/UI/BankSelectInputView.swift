//
//  BankSelectInputView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/05.
//

import UIKit
import SnapKit
import Then

final class BankSelectInputView: UIView {
    private let bankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .placeholderText
        $0.text = "은행 선택"
        $0.numberOfLines = 1
    }
    
    private let chevron = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .placeholderText
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ name: String) {
        bankLabel.text = name.isEmpty ? "은행 선택" : name
        bankLabel.textColor = name.isEmpty ? .placeholderText : .label
    }
}

private extension BankSelectInputView {
    func configureLayout() {
        addSubview(bankLabel)
        bankLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.leading.equalTo(bankLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalTo(bankLabel)
        }
        
        addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(bankLabel.snp.bottom).offset(4)
            make.height.equalTo(2)
        }
    }
}
