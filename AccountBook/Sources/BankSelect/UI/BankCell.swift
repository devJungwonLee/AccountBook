//
//  BankCell.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/07.
//

import UIKit
import SnapKit
import Then

struct BankCellState: Hashable {
    let code: String
    let name: String
    
    init(_ bank: Bank) {
        self.code = bank.code
        self.name = bank.name
    }
}

final class BankCell: UICollectionViewCell {
    private let logoImageView = UIImageView().then {
        $0.backgroundColor = .secondarySystemBackground
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellState: BankCellState) {
        titleLabel.text = cellState.name
        logoImageView.image = UIImage(named: cellState.code)
    }
}

private extension BankCell {
    func configureAttributes() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
    }
    
    func configureLayout() {
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(4)
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
