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
    
    func showTwoButtonAlert(title: String = "알림", message: String, defaultButtonTitle: String = "확인", cancelButtonTitle: String = "취소", defaultAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelAction)
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showThreeButtonAlert(title: String = "알림", message: String, defaultButtonTitle: String = "확인", cancelButtonTitle: String = "취소", destructiveButtonTitle: String, defaultAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil, destructiveAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultAction)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelAction)
        let destructiveAction = UIAlertAction(title: destructiveButtonTitle, style: .destructive, handler: destructiveAction)
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
