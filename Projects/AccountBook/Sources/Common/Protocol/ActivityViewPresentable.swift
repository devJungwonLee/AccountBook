//
//  ActivityViewPresentable.swift
//  AccountBook
//
//  Created by 이정원 on 7/18/23.
//

import UIKit

protocol ActivityViewPresentable where Self: UIViewController {
    func presentActivityView(with urlString: String)
}

extension ActivityViewPresentable {
    func presentActivityView(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let activityViewController = UIActivityViewController(
            activityItems: [url], applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
}
