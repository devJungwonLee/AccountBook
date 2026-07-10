//
//  KeyboardObservable.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import UIKit

protocol KeyboardObservable where Self: UIViewController {
    var scrollView: UIScrollView { get set }
}

extension KeyboardObservable {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [weak self] notification in
                self?.keyboardWillShow(notification)
            }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [weak self] notification in
                self?.keyboardWillHide(notification)
            }
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
              let keyboardFrame = userInfo as? NSValue else  {
            return
        }
        
        let keybaordRectangle = keyboardFrame.cgRectValue
        var keyboardHeight = keybaordRectangle.height
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let scrollViewHeight = scrollView.frame.height
        let diff = safeAreaHeight - scrollViewHeight
        
        keyboardHeight -= view.safeAreaInsets.bottom
        keyboardHeight -= diff
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = inset
        scrollView.scrollIndicatorInsets = inset
        scrollView.scrollToBottom()
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
