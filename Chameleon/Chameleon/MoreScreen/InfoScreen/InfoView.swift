//
//  InfoView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/06/14.
//

import UIKit

final class InfoView: UIView {
    
    //MARK: - Views
    var closeButton: UIButton!
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var versionLabel: UILabel!
    var updateButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = .backgroundColor
        
        setupCloseButton()
        setupIconImage()
        setupTitleLabel()
        setupVersionLabel()
        
        setupUpdateButton()
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.label, for: .normal)
        
        self.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupIconImage() {
        if let iconImage = UIImage(named: "AppIconImage") {
            iconImageView = UIImageView(image: iconImage)
        } else {
            iconImageView = UIImageView()
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let size: CGFloat = 120
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = size / 5
        
        self.addSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "카멜레온"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setupVersionLabel() {
        versionLabel = UILabel()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.numberOfLines = 0
        
        versionLabel.text = "현재 버전 : \(BaseData.shared.currentVersion)\n최신 버전 : \(BaseData.shared.lastetVersion)"
        versionLabel.font = UIFont.systemFont(ofSize: 16)
        
        self.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setupUpdateButton() {
        updateButton = UIButton()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        if BaseData.shared.isNeedUpdate {
            updateButton.applyMainButtonStyle(title: "최신 버전으로 업데이트")
            updateButton.isEnabled = true
        } else {
            updateButton.applyMainButtonStyle(title: "최신 버전입니다.")
            updateButton.isEnabled = false
        }
        
        let width = min(self.frame.width - 80, 800)
        self.addSubview(updateButton)
        updateButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
