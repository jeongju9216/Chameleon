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
    private var LoadingTime: Double = 2
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setupLogoImage()
        setupBottomView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + LoadingTime) {
            self.presentNextVC()
        }
    }
    
    //MARK: - Methods
    private func presentNextVC() {
        let vc: UIViewController = CustomTabBarController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: - Setup
    private func setupLogoImage() {
        logoImage = UIImageView(image: UIImage(named: "LogoImage"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(logoImage)
        logoImage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1).isActive = true
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
