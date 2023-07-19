//
//  OpenSourceLicenseInteractor.swift
//  AccountBook
//
//  Created by 이정원 on 7/19/23.
//

import ModernRIBs
import Foundation

protocol OpenSourceLicenseRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OpenSourceLicensePresentable: Presentable {
    var listener: OpenSourceLicensePresentableListener? { get set }
    func displayOpenSourceInfo(frameworks: [Framework], licenses: [License])
}

protocol OpenSourceLicenseListener: AnyObject {
    func closeOpenSourceLicense()
}

final class OpenSourceLicenseInteractor: PresentableInteractor<OpenSourceLicensePresentable>, OpenSourceLicenseInteractable, OpenSourceLicensePresentableListener {

    weak var router: OpenSourceLicenseRouting?
    weak var listener: OpenSourceLicenseListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OpenSourceLicensePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didDisappear() {
        listener?.closeOpenSourceLicense()
    }
    
    func viewDidLoad() {
        let frameworks = fetchFrameworkList()
        let licenses = fetchLicenseList()
        presenter.displayOpenSourceInfo(frameworks: frameworks, licenses: licenses)
    }
    
    private func fetchFrameworkList() -> [Framework] {
        guard let url = Bundle.main.url(forResource: "FrameworkList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let frameworks = try? JSONDecoder().decode([Framework].self, from: data) else {
            return []
        }
        return frameworks
    }
    
    private func fetchLicenseList() -> [License] {
        guard let url = Bundle.main.url(forResource: "LicenseList", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let titles = try? JSONSerialization.jsonObject(with: data) as? [String] else {
            return []
        }
        return titles.compactMap { title in
            guard let url = Bundle.main.url(forResource: title, withExtension: "txt"),
                  let contents = try? String(contentsOf: url, encoding: .utf8) else {
                return nil
            }
            return License(title: title, contents: contents)
        }
    }
}
