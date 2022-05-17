//
//  HomeView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

class HomeView: UIView {
    
    //MARK: - Views
    var buttonStack: UIStackView!
    var photoButton: HomeMenuButton!
    var videoButton: HomeMenuButton!
    
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
        
        setupButtonStack()
        setupPhotoButton()
        setupVideoButton()
        
        videoButton.isHidden = true //영상 속도 개선하면 show
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
