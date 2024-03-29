//
//  AlertPresentable.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/09.
//

import UIKit

protocol AlertPresentable where Self: UIViewController {
    func presentTextFieldAlert(title: String, message: String?, completion: @escaping (String) -> Void)
    func presentNoticeAlert(title: String?, message: String?, completion: (() -> Void)?)
    func presentAskAlert(title: String?, message: String?, completion: @escaping () -> Void)
}

extension AlertPresentable {
    func presentNoticeAlert(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirm)
        present(alertController, animated: true)
    }
    
    func presentAskAlert(title: String? = nil, message: String? = nil, completion: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func presentTextFieldAlert(title: String, message: String? = nil, completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            guard let bankName = alertController.textFields?[0].text else { return }
            completion(bankName)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        
        alertController.addTextField {
            $0.tintColor = .main
        }
        alertController.addTextFieldTarget()
        
        present(alertController, animated: true)
    }
}
