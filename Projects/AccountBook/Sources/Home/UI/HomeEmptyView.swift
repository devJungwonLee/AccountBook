//
//  HomeEmptyView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit
import Then

final class HomeEmptyView: UIView {
    private let iconLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 80)
        $0.text = "🏦"
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 2
        $0.text = "계좌를 등록해서 계좌번호를\n빠르게 복사해보세요!"
        $0.textAlignment = .center
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        iconLabel, titleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeEmptyView {
    func configureLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
