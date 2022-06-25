//
//  LaunchView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit
import Lottie

final class LaunchView: UIView {
    
    //MARK: - Views
    var logoImage: UIImageView! //카멜레온 로고 이미지
    var animationView: AnimationView! //하단 애니메이션 뷰
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor
        
        setupLogoImage()
        setupBottomView()
    }
    
    private func setupLogoImage() {
        logoImage = UIImageView(image: UIImage(named: "LogoImage"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage.contentMode = .scaleAspectFit
        
        self.addSubview(logoImage)
        logoImage.widthAnchor.constraint(lessThanOrEqualToConstant: 320).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
    }
    
    private func setupBottomView() {
        let userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        let animationName = (userInterfaceStyle == .light) ? "bottomImage-Light" : "bottomImage-Dark"
        animationView = .init(name: animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.contentMode = .scaleToFill //레이아웃에 꽉 차게
        animationView.loopMode = .loop //무한 반복
        animationView.animationSpeed = 1.2 //1.2배속으로 진행
        animationView.play()
        
        self.addSubview(animationView)
        animationView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 20).isActive = true
    }
}
