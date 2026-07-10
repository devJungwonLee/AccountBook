//
//  SafariPresentable.swift
//  AccountBook
//
//  Created by 이정원 on 7/18/23.
//

import UIKit
import SafariServices

protocol SafariPresentable where Self: UIViewController {
    func presentSafari(with urlString: String)
}

extension SafariPresentable {
    func presentSafari(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}
