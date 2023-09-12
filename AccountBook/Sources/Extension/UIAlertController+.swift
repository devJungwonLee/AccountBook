//
//  UIAlertController+.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/09.
//

import UIKit

extension UIAlertController: UITextFieldDelegate {
    func addTextFieldTarget() {
        guard let textFields else { return }
        textFields[0].addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc func textChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text == " " { textField.text = "" }
        else if text.count > 20 {
            textField.text = text.map { String($0) }[0..<20].reduce("", +)
        }
    }
}

