//
//  ToastView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/24.
//

import UIKit
import SnapKit
import Then

final class ToastView: UIView {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureAttributes()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: String) {
        titleLabel.text = message
    }
}

private extension ToastView {
    func configureAttributes() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
    }
    
    func configureLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(12)
        }
    }
}
