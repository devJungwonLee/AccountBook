//
//  MyAccountCell.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit
import SnapKit
import Then

final class MyAccountCell: UICollectionViewCell {
    private let bankLogoView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 24
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 2
    }
    
    private let numberLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .systemGray
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        nameLabel, numberLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let copyButton = UIButton(configuration: .filled()).then {
        $0.configuration?.baseBackgroundColor = .systemGroupedBackground
        $0.configuration?.baseForegroundColor = .darkGray
        $0.configuration?.cornerStyle = .large
        var attributedString = AttributedString("복사")
        attributedString.font = .systemFont(ofSize: 16, weight: .medium)
        $0.configuration?.attributedTitle = attributedString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with account: Account) {
        nameLabel.text = account.name
        numberLabel.text = account.number
    }
}

private extension MyAccountCell {
    func configureAttributes() {
        
    }
    
    func configureLayout() {
        contentView.addSubview(bankLogoView)
        bankLogoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(20).priority(.high)
            make.width.height.equalTo(48)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(bankLogoView.snp.trailing).offset(20)
            make.centerY.equalTo(bankLogoView.snp.centerY)
        }
        
        contentView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.centerY.equalTo(bankLogoView.snp.centerY)
        }
    }
}
