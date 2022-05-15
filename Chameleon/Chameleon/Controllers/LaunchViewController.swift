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
        
        HttpService.shared.loadVersion(completionHandler: { [weak self] (result, response) in
            print("[loadVersion] result: \(result) / response: \(response)")
            if result {
                self?.setupAppInfo(lastetVersion: (response as! Response).message ?? "0.0.0")
                self?.presentNextVC()
            } else {
                self?.showErrorAlert(erorr: "서버 통신에 실패했습니다.", action: { _ in
                    self?.presentNextVC()
                })
            }
        })
    }
    
    //MARK: - Methods
    private func setupAppInfo(lastetVersion: String) {
        BaseData.shared.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        BaseData.shared.lastetVersion = lastetVersion

        print("currentVersion: \(BaseData.shared.currentVersion) / lastetVersion: \(BaseData.shared.lastetVersion)")
    }
    
    private func presentNextVC() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.LoadingTime) {
            let vc: UIViewController = CustomTabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: - Setup
    private func setupLogoImage() {
        logoImage = UIImageView(image: UIImage(named: "LogoImage"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(logoImage)
        logoImage.widthAnchor.constraint(lessThanOrEqualToConstant: 320).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -20).isActive = true
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
