//
//  BankCollectionView.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/07.
//

import UIKit

final class BankCollectionView: UICollectionView {
    init(frame: CGRect = .zero) {
        super.init(frame: frame, collectionViewLayout: .init())
        configureAttributes()
        configureCompositionalLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension BankCollectionView {
    func configureAttributes() {
        backgroundColor = .systemBackground
    }
    
    func configureCompositionalLayout() {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0 / 3.0),
                heightDimension: .estimated(100)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 8, leading: 8, bottom: 0, trailing: 8)
        collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
