//
//  SettingCell.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import UIKit

protocol SettingCellDelegate: AnyObject {
    func switchTapped(_ isOn: Bool)
}

struct SettingCellState: Hashable {
    let title: String
    let isOn: Bool?
    
    init(_ menu: SettingMenu) {
        self.title = menu.title
        self.isOn = menu.isOn
    }
}

final class SettingCell: UICollectionViewListCell {
    weak var delegate: SettingCellDelegate?
    
    private lazy var accountNumberHidingSwitch = UISwitch().then {
        $0.onTintColor = .main
        $0.isOn = false
        $0.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cellState: SettingCellState) {
        var content = defaultContentConfiguration()
        content.text = cellState.title
        contentConfiguration = content
        
        if let isOn = cellState.isOn {
            accountNumberHidingSwitch.isOn = isOn
            accessories = [
                .customView(
                    configuration: .init(
                        customView: accountNumberHidingSwitch,
                        placement: .trailing()
                    )
                )
            ]
        } else {
            accessories = [.disclosureIndicator()]
        }
    }
}

private extension SettingCell {
    @objc func switchTapped() {
        let isOn = accountNumberHidingSwitch.isOn
        accountNumberHidingSwitch.isOn.toggle()
        delegate?.switchTapped(isOn)
    }
}
