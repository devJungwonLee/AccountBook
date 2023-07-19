//
//  FrameworkCell.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import UIKit
import SnapKit
import Then

protocol FrameworkCellDelegate: AnyObject {
    func urlButtonTapped(_ cell: FrameworkCell)
}

struct FrameworkCellState: Hashable {
    let title: String
    let urlString: String
    let copyright: String
    let license: String
    
    init(_ framework: Framework) {
        self.title = framework.title
        self.urlString = framework.urlString
        self.copyright = framework.copyright
        self.license = framework.license
    }
}

final class FrameworkCell: UICollectionViewListCell {
    weak var delegate: FrameworkCellDelegate?
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private lazy var urlButton = UIButton(configuration: .plain()).then {
        $0.configuration?.baseForegroundColor = .systemBlue
        $0.configuration?.contentInsets = .zero
        $0.contentHorizontalAlignment = .leading
        $0.addTarget(self, action: #selector(urlButtonTapped), for: .touchUpInside)
    }
    
    private let copyrightLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray
        $0.numberOfLines = 0
    }
    
    private let licenseLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        urlButton, copyrightLabel, licenseLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellState: FrameworkCellState) {
        var buttonTitle = AttributedString(cellState.urlString)
        buttonTitle.font = .systemFont(ofSize: 14)
        titleLabel.text = cellState.title
        urlButton.configuration?.attributedTitle = buttonTitle
        urlButton.configuration?.attributedTitle?.underlineStyle = .init(rawValue: 1)
        copyrightLabel.text = cellState.copyright
        licenseLabel.text = cellState.license
    }
}

private extension FrameworkCell {
    func configureAttributes() {
        contentView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(36)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc func urlButtonTapped() {
        delegate?.urlButtonTapped(self)
    }
}
