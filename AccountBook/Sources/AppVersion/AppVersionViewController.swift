//
//  AppVersionViewController.swift
//  AccountBook
//
//  Created by 이정원 on 7/20/23.
//

import ModernRIBs
import UIKit

protocol AppVersionPresentableListener: AnyObject {
    func didDisappear()
}

final class AppVersionViewController: UIViewController, AppVersionPresentable, AppVersionViewControllable {
    weak var listener: AppVersionPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if isMovingFromParent {
            listener?.didDisappear()
        }
    }
}

private extension AppVersionViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
}
