//
//  MyAccountCell.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit
import SnapKit
import Then

struct MyAccountCellState: Hashable {
    let id = UUID()
    let bank: Bank
    let number: String
    let name: String
    
    init(_ account: Account) {
        self.bank = account.bank
        self.number = account.number
        self.name = account.name
    }
}

final class MyAccountCell: UICollectionViewCell {
    private let bankLogoImageView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
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
    
    func configure(with cellState: MyAccountCellState) {
        bankLogoImageView.image = UIImage(named: cellState.bank.code)
        nameLabel.text = cellState.name
        numberLabel.text = cellState.number
    }
}

private extension MyAccountCell {
    func configureAttributes() {
        
    }
    
    func configureLayout() {
        contentView.addSubview(bankLogoImageView)
        bankLogoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(20).priority(.high)
            make.width.height.equalTo(48)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(bankLogoImageView.snp.trailing).offset(20)
            make.centerY.equalTo(bankLogoImageView.snp.centerY)
        }
        
        contentView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.centerY.equalTo(bankLogoImageView.snp.centerY)
        }
    }
}
