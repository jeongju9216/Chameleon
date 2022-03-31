//
//  LaunchViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import Lottie
import SnapKit
import FirebaseAuth

class LaunchViewController: UIViewController {
    
    //MARK: - Views
    let logoImage: UIImageView = UIImageView()
    lazy var animationView: AnimationView = {
        UITraitCollection.current.userInterfaceStyle == .light ? .init(name: "bottomImage-Light")
                                                               : .init(name: "bottomImage-Dark")
    }()

    //MARK: - Properties
    private var isAutoLogin: Bool = false
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
//        checkAutoLogin()
        
        setupLogoImage()
        setupBottomView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if !self.isAutoLogin {
                self.logoImage.snp.remakeConstraints { make in
                    make.height.equalTo(self.view.frame.height * 0.1)
                    make.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
                    make.right.equalToSuperview().offset(-40)
                    make.left.equalToSuperview().offset(40)
                }
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.animationView.isHidden = true
                    self?.view.layoutIfNeeded()
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.3) {
            self.dismiss(animated: false, completion: {
                if self.isAutoLogin {
                    let homeVC = CustomTabBarController()
                    homeVC.modalPresentationStyle = .fullScreen
                    homeVC.modalTransitionStyle = .crossDissolve
                    self.present(homeVC, animated: true, completion: nil)
                } else {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: false, completion: nil)
                }
                
            })
        }
    }
    
    //MARK: - Methods
    private func checkAutoLogin() {
        if let email = UserDefaults.standard.string(forKey: "email"),
           let password = UserDefaults.standard.string(forKey: "password") {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                if error == nil {
                    self?.isAutoLogin = true
                    User.shared.email = email
                } else {
                    print("Login Error: \(String(describing: error))")
                }
            }
        }
    }
    
    private func setupLogoImage() {
        logoImage.image = UIImage(named: "LogoImage")
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height * 0.1)
            make.centerY.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(40)
        }
    }
    
    private func setupBottomView() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        animationView.play()
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.height.equalTo(180)
            make.bottom.equalTo(view.snp.bottom).offset(20)
        }
    }
}
