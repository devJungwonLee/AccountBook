//
//  AccountRegisterViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/04.
//

import ModernRIBs
import UIKit

protocol AccountRegisterPresentableListener: AnyObject {
    func didDisappear()
}

final class AccountRegisterViewController: UIViewController, AccountRegisterPresentable, AccountRegisterViewControllable {

    weak var listener: AccountRegisterPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
}

private extension AccountRegisterViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
}
