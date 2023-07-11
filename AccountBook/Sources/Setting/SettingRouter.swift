//
//  SettingRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/05/31.
//

import ModernRIBs

protocol SettingInteractable: Interactable, BackupRecoveryListener {
    var router: SettingRouting? { get set }
    var listener: SettingListener? { get set }
}

protocol SettingViewControllable: ViewControllable {
    func push(viewController: ViewControllable)
}

final class SettingRouter: ViewableRouter<SettingInteractable, SettingViewControllable>, SettingRouting {
    private let backupRecoveryBuilder: BackupRecoveryBuildable
    private var backupRecoveryRouter: BackupRecoveryRouting?
    
    init(
        backupRecoveryBuilder: BackupRecoveryBuildable,
        interactor: SettingInteractable,
        viewController: SettingViewControllable
    ) {
        self.backupRecoveryBuilder = backupRecoveryBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachBackupRecovery() {
        let backupRecoveryRouter = backupRecoveryBuilder.build(withListener: interactor)
        self.backupRecoveryRouter = backupRecoveryRouter
        attachChild(backupRecoveryRouter)
        viewController.push(viewController: backupRecoveryRouter.viewControllable)
    }
    
    func detachBackupRecovery() {
        guard let backupRecoveryRouter else { return }
        detachChild(backupRecoveryRouter)
        self.backupRecoveryRouter = nil
    }
}
