//
//  UnderLineTextField.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/05.
//

import UIKit
import SnapKit
import Then

final class UnderLineTextField: UITextField {
    private let underLine = UIView().then {
        $0.backgroundColor = .secondarySystemBackground
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUnderLine(_ isError: Bool) {
        underLine.backgroundColor = isError ? .systemRed : .secondarySystemBackground
    }
}

private extension UnderLineTextField {
    func configureAttributes() {
        borderStyle = .none
        font = .systemFont(ofSize: 24, weight: .medium)
        tintColor = .main
        clearButtonMode = .whileEditing
    }
    
    func configureLayout() {
        addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
            make.top.equalTo(snp.bottom).offset(4)
        }
    }
}
