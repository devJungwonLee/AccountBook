//
//  BackupRecoveryRouter.swift
//  AccountBook
//
//  Created by 이정원 on 2023/07/11.
//

import ModernRIBs

protocol BackupRecoveryInteractable: Interactable {
    var router: BackupRecoveryRouting? { get set }
    var listener: BackupRecoveryListener? { get set }
}

protocol BackupRecoveryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class BackupRecoveryRouter: ViewableRouter<BackupRecoveryInteractable, BackupRecoveryViewControllable>, BackupRecoveryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: BackupRecoveryInteractable, viewController: BackupRecoveryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
