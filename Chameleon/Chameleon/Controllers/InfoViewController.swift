//
//  InfoViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/10.
//

import UIKit

class InfoViewController: BaseViewController {
    
    //MARK: - Views
    private var closeButton: UIButton!
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfoView()
        
        closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Methods
    private func setupInfoView() {
        view.backgroundColor = .backgroundColor
        
        setupCloseButton()
        setupIconImage()
        setupTitleLabel()
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("닫기", for: .normal)
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupIconImage() {
        if let iconImage = UIImage(named: "AppIconImage") {
            iconImageView = UIImageView(image: iconImage)
        } else {
            iconImageView = UIImageView()
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let size: CGFloat = 150
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = size / 5
        
        view.addSubview(iconImageView)
        iconImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "카멜레온"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
}
