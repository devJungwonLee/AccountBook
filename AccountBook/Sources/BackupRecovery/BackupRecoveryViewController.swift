//
//  BackupRecoveryViewController.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs
import UIKit

protocol BackupRecoveryPresentableListener: AnyObject {
    func didDisappear()
}

final class BackupRecoveryViewController: UIViewController, BackupRecoveryPresentable, BackupRecoveryViewControllable {
    weak var listener: BackupRecoveryPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "데이터 백업 및 복구"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.didDisappear()
    }
}
