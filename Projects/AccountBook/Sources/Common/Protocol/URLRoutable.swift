//
//  URLRoutable.swift
//  AccountBook
//
//  Created by 이정원 on 7/18/23.
//

import UIKit

protocol URLRoutable where Self: UIViewController {
    func open(with urlString: String)
}

extension URLRoutable {
    func open(with urlString: String) {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
