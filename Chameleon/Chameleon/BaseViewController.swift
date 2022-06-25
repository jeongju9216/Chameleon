//
//  BaseViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit

class BaseViewController: UIViewController {
    
    func setupNavigationBar(title: String) { //네비게이션 UI 속성 적용
        navigationItem.title = title //제목 설정
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil) //back 버튼 글자 삭제
        
        //배경색 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.backgroundColor
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        //shadow 설정
        navigationController?.navigationBar.layer.masksToBounds = false //둥근 shadow 적용을 위해 false
        navigationController?.navigationBar.layer.shadowColor = UIColor.shadowColor.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowRadius = 5
        
        //title 색 설정
        navigationController?.navigationBar.tintColor = .label
    }
    
    /*
     1개 버튼 Alert.
     doneButton은 doneAction 이름의 UIAlertAction을 인자로 전달 받아 동작한다.
     doneAction이 nil인 경우 Alert가 dismiss 된다.
    */
    func showOneButtonAlert(title: String = "알림", message: String, buttonTitle: String = "확인",
                            action: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
            alert.addAction(doneAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
     2개 버튼 Alert.
     doneButton은 defaultAction 이름의 UIAlertAction을 인자로 전달 받아 동작한다.
     defaultAction이 nil인 경우 Alert가 dismiss 된다.
     cancelButton은 cancelAction을 인자로 전달 받아 동작한다.
     cancelAction이 nil인 경우 Alert가 dismiss 된다.
    */
    func showTwoButtonAlert(title: String = "알림", message: String,
                            defaultButtonTitle: String = "확인", cancelButtonTitle: String = "취소",
                            defaultAction: ((UIAlertAction) -> Void)? = nil, cancelAction: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultAction)
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelAction)
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
     error 발생시 Alert.
     에러가 발생했다는 기본 메시지를 가진 one button Alert이다.
     doneButton은 action 이름의 UIAlertAction을 인자로 전달 받아 동작한다.
     action이 nil인 경우 Alert가 dismiss 된다.
    */
    func showErrorAlert(erorr: String = "에러가 발생했습니다.\n다시 시도해 주세요.",
                        action: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "에러", message: erorr, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "확인", style: .default, handler: action)
            alert.addAction(doneAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
