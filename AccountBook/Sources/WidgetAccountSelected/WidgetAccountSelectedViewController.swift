//
//  WidgetAccountSelectedViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/09.
//

import ModernRIBs
import UIKit
import SnapKit
import Then

protocol WidgetAccountSelectedPresentableListener: AnyObject {
    func doneButtonTapped()
    func didDisappear()
}

final class WidgetAccountSelectedViewController: UIViewController, WidgetAccountSelectedPresentable, WidgetAccountSelectedViewControllable {
    weak var listener: WidgetAccountSelectedPresentableListener?
    
    private lazy var doneButton = UIButton(configuration: .filled()).then {
        var attributedString = AttributedString("확인")
        attributedString.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.configuration?.attributedTitle = attributedString
        $0.configuration?.baseBackgroundColor = .main
        $0.configuration?.baseForegroundColor = .white
        $0.configuration?.cornerStyle = .large
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
        configureLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}

private extension WidgetAccountSelectedViewController {
    func configureAttributes() {
        view.backgroundColor = .systemBackground
    }
    
    func configureLayout() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
    @objc func doneButtonTapped() {
        listener?.doneButtonTapped()
    }
}
