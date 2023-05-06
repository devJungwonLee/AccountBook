//
//  BankSelectViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/06.
//

import ModernRIBs
import UIKit

protocol BankSelectPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class BankSelectViewController: UIViewController, BankSelectPresentable, BankSelectViewControllable {

    weak var listener: BankSelectPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
    }
}
