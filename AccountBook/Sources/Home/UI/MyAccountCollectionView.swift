//
//  MyAccountCollectionView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/03.
//

import UIKit

final class MyAccountCollectionView: UICollectionView {
    init(frame: CGRect = .zero) {
        super.init(frame: frame, collectionViewLayout: .init())
        configureAttributes()
        configureCompositionalLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension MyAccountCollectionView {
    func configureAttributes() {
        backgroundColor = .systemBackground
        contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func configureCompositionalLayout() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
}
