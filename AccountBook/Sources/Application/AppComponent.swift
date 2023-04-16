//
//  AppComponent.swift
//  AccountBook
//
//  Created by 이정원 on 2023/04/16.
//

import ModernRIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
