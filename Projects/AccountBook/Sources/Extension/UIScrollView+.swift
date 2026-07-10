//
//  UIScrollView+.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import UIKit

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(
            x: 0,
            y: contentSize.height - bounds.size.height + contentInset.bottom
        )
        
        if (bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
