//
//  RootViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import ModernRIBs
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RootViewController: LoggedInViewControllable {
    func present(viewController: ModernRIBs.ViewControllable) {
        viewController.uiviewController.modalPresentationStyle = .overFullScreen
        present(viewController.uiviewController, animated: false)
    }
}
