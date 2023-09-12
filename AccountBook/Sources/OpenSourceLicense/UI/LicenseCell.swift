//
//  LicenseCell.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import UIKit
import SnapKit
import Then

struct LicenseCellState: Hashable {
    let title: String
    let contents: String
    
    init(_ license: License) {
        self.title = license.title
        self.contents = license.contents
    }
}

final class LicenseCell: UICollectionViewListCell {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .semibold)
    }
    
    private let contentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellState: LicenseCellState) {
        titleLabel.text = cellState.title
        contentsLabel.text = cellState.contents
    }
}

private extension LicenseCell {
    func configureAttributes() {
        contentView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(36)
        }
        
        contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
