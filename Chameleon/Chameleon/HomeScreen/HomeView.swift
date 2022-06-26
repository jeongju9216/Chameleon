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
    
    private var tabbarBorderView: UIView! //탭바 테두리 View
    private var tabbarHeight: CGFloat = 0 //탭바 높이
    private var tabbarPadding: CGFloat = 0 //safeArea bottom padding
    
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
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor
        setupTabbarBorder()
        
        setupButtonStack()
        setupPhotoButton()
        setupVideoButton()
    
        videoButton.isHidden = true //영상 속도 개선하면 show
    }
    
    private func setupTabbarBorder() {
        tabbarBorderView = UIView(frame: .zero)
        tabbarBorderView.translatesAutoresizingMaskIntoConstraints = false

        tabbarBorderView.backgroundColor = UIColor(named: "TabBarBorderColor")
        tabbarBorderView.alpha = 0.5
        tabbarBorderView.layer.cornerRadius = (tabbarHeight - tabbarPadding) * 0.30 //홈키 유무에 따라 padding값 고려
        tabbarBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.addSubview(tabbarBorderView)
        tabbarBorderView.widthAnchor.constraint(equalToConstant: self.frame.width + 3).isActive = true
        tabbarBorderView.heightAnchor.constraint(equalToConstant: tabbarHeight).isActive = true
        tabbarBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tabbarBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
    }
    
    private func setupButtonStack() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal //가로로 버튼 배치
        buttonStack.spacing = 20
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually //같은 너비로 아이템 배치
        
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
