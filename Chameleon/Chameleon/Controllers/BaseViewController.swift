//
//  BaseViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit

class BaseViewController: UIViewController {
    func setupNavigationBar(title: String) {
        navigationItem.title = title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.backgroundColor
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.shadowColor.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowRadius = 5
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    func showOneButtonAlert(title: String = "알림", message: String, buttonTitle: String = "확인", action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alert.addAction(doneAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
