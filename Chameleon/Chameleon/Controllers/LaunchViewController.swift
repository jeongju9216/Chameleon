//
//  LaunchViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import Lottie

class LaunchViewController: BaseViewController {
    
    //MARK: - Views
    var logoImage: UIImageView!
    var animationView: AnimationView!

    //MARK: - Properties
    private var isAutoLogin: Bool = false
    
    var imageTopConstraint: NSLayoutConstraint?
    var imageCenterYConstraint: NSLayoutConstraint?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        checkAutoLogin()
        
        setupLogoImage()
        setupBottomView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.logoAnimation()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.3) {
            self.presentNextViewController()
        }
    }
    
    //MARK: - Methods
    private func logoAnimation() {
        if !isAutoLogin {
            imageCenterYConstraint?.isActive = false
            logoImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.animationView.isHidden = true
                self?.view.layoutIfNeeded()
            })
        }
    }
    
    private func presentNextViewController() {
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
    
    private func checkAutoLogin() {
        if let email = UserDefaults.standard.string(forKey: "email"),
           let password = UserDefaults.standard.string(forKey: "password") {
            FirebaseService.shared.login(withEmail: email, password: password, completion: { [weak self] (authResult, error) in
                if let error = error {
                    print("Login Error: \(error)")
                } else {
                    if let user = authResult?.user {
                        FirebaseService.shared.fetchUserData(user: user)
                    }
                    
                    self?.isAutoLogin = true
                }
            })
        }
    }
    
    //MARK: - Setup
    private func setupLogoImage() {
        logoImage = UIImageView(image: UIImage(named: "LogoImage"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(logoImage)
        logoImage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1).isActive = true
        imageCenterYConstraint = logoImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20)
        imageCenterYConstraint?.isActive = true
        logoImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40).isActive = true
        logoImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupBottomView() {
        let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        let animationName = (userInterfaceStyle == .light) ? "bottomImage-Light" : "bottomImage-Dark"
        animationView = .init(name: animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.2
        animationView.play()
        
        view.addSubview(animationView)
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
    }
}
