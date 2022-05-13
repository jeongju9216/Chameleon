//
//  LoadingIndicator.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/09.
//

import UIKit

final class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            guard let rootVC: UIViewController = UIApplication.shared.keyWindow?.rootViewController,
                  let presentedVC: UIViewController = rootVC.presentedViewController else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.frame = presentedVC.view.frame //다른 UI가 눌리지 않도록
            loadingIndicatorView.color = .white
            presentedVC.view.addSubview(loadingIndicatorView)

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let rootVC: UIViewController = UIApplication.shared.keyWindow?.rootViewController,
                  let presentedVC: UIViewController = rootVC.presentedViewController else { return }
            
            presentedVC.view.subviews.filter({ $0 is UIActivityIndicatorView }).forEach {
                $0.removeFromSuperview()
            }
        }
    }
}
