//
//  HomeView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: - Views
    var buttonStack: UIStackView!
    var photoButton: HomeMenuButton!
    var videoButton: HomeMenuButton!
    
    private var tabbarBorderView: UIView!
    private var tabbarHeight: CGFloat = 0
    private var tabbarPadding: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, tabbarHeight: CGFloat, tabbarPadding: CGFloat) {
        self.init(frame: frame)
        
        self.tabbarHeight = tabbarHeight
        self.tabbarPadding = tabbarPadding
        print("tabbarHeight: \(tabbarHeight) / tabbarPadding: \(tabbarPadding)")
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor
        
        setupButtonStack()
        setupPhotoButton()
        setupVideoButton()
//        setupTabbarBorder()

        videoButton.isHidden = true //영상 속도 개선하면 show
    }
    
    private func setupTabbarBorder() {
        tabbarBorderView = UIView(frame: .zero)
        tabbarBorderView.translatesAutoresizingMaskIntoConstraints = false

        tabbarBorderView.backgroundColor = UIColor(named: "TabBarBorderColor")
        tabbarBorderView.alpha = 0.5
        tabbarBorderView.layer.cornerRadius = (tabbarHeight - tabbarPadding - 10) * 0.41
        tabbarBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.addSubview(tabbarBorderView)
        tabbarBorderView.widthAnchor.constraint(equalToConstant: self.frame.width + 3).isActive = true
        tabbarBorderView.heightAnchor.constraint(equalToConstant: tabbarHeight - 10).isActive = true
        tabbarBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tabbarBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13).isActive = true
    }
    
    private func setupButtonStack() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        
        self.addSubview(buttonStack)
        let width: CGFloat = self.frame.width * 0.8
        buttonStack.widthAnchor.constraint(equalToConstant: width).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: width * 0.35).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    }
    
    private func setupPhotoButton() {
        photoButton = HomeMenuButton(imageName: "PhotoButton", name: "PHOTO")
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(photoButton)
        photoButton.heightAnchor.constraint(equalTo: buttonStack.heightAnchor).isActive = true
    }
    
    private func setupVideoButton() {
        videoButton = HomeMenuButton(imageName: "VideoButton", name: "VIDEO")
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(videoButton)
        videoButton.heightAnchor.constraint(equalTo: buttonStack.heightAnchor).isActive = true
    }
}
