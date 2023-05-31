//
//  SettingCell.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import UIKit

struct SettingCellState: Hashable {
    let title: String
    let isOn: Bool?
    
    init(title: String, isOn: Bool? = nil) {
        self.title = title
        self.isOn = isOn
    }
}

final class SettingCell: UICollectionViewListCell {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
    }
    
    private let toggle = UISwitch().then {
        $0.isOn = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellState: SettingCellState) {
        titleLabel.text = cellState.title
        if let isOn = cellState.isOn {
            toggle.isOn = isOn
        } else {
            toggle.isHidden = true
        }
    }
}

private extension SettingCell {
    func configureAttributes() {
        contentView.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(toggle)
        toggle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
