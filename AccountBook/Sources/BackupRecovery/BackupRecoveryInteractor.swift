//
//  BackupRecoveryInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs

protocol BackupRecoveryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BackupRecoveryPresentable: Presentable {
    var listener: BackupRecoveryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol BackupRecoveryListener: AnyObject {
    func closeBackupRecovery()
}

final class BackupRecoveryInteractor: PresentableInteractor<BackupRecoveryPresentable>, BackupRecoveryInteractable, BackupRecoveryPresentableListener {

    weak var router: BackupRecoveryRouting?
    weak var listener: BackupRecoveryListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: BackupRecoveryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didDisappear() {
        listener?.closeBackupRecovery()
    }
}
