//
//  RootViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import ModernRIBs
import UIKit
import SnapKit

protocol RootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootViewControllable {
    weak var listener: RootPresentableListener?
    private let indicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
    }
}

private extension RootViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

extension RootViewController: LoggedInViewControllable {
    func present(viewController: ModernRIBs.ViewControllable) {
        viewController.uiviewController.modalPresentationStyle = .overFullScreen
        present(viewController.uiviewController, animated: false)
    }
}

extension RootViewController: RootPresentable {
    func setLoading(_ isLoading: Bool) {
        switch isLoading {
        case true: indicator.startAnimating()
        case false: indicator.stopAnimating()
        }
    }
}
