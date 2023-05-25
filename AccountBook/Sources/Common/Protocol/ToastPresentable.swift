//
//  ToastPresentable.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/24.
//

import UIKit
import SnapKit
import Then

protocol ToastPresentable where Self: UIViewController {
    func showToast(message: String)
}

extension ToastPresentable {
    func showToast(message: String) {
        let toastView = ToastView()
        toastView.configure(with: message)
        
        view.addSubview(toastView)
        toastView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseInOut, animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
}
