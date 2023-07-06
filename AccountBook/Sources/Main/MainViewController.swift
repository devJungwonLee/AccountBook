//
//  MainViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/02.
//

import ModernRIBs
import UIKit

protocol MainPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainViewController: UITabBarController, MainPresentable, MainViewControllable {
    weak var listener: MainPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
    }
    
    func configureChildTabs(viewControllers: [ModernRIBs.ViewControllable]) {
        self.viewControllers = viewControllers.map {
            UINavigationController(rootViewController: $0.uiviewController)
        }
        (self.viewControllers?.last as? UINavigationController)?.navigationBar.prefersLargeTitles = true
    }
    
    func present(viewController: ViewControllable) {
        presentedViewController?.dismiss(animated: false)
        let viewController = viewController.uiviewController
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
}

private extension MainViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .black
    }
}
