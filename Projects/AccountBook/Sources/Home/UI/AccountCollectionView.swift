//
//  AccountCollectionView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit

final class AccountCollectionView: UICollectionView {
    init(frame: CGRect = .zero) {
        super.init(frame: frame, collectionViewLayout: .init())
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension AccountCollectionView {
    func configureAttributes() {
        backgroundColor = .systemBackground
        contentInset = .init(top: 20, left: 0, bottom: 80, right: 0)
    }
}
