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
    private var versionLabel: UILabel!
    private var updateButton: UIButton!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfoView()
        
        closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(clickedUpdateButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func clickedUpdateButton(sender: UIButton) {
        openAppStore()
    }
    
    //MARK: - Methods
    private func openAppStore() {
        let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(BaseData.shared.appleID)"
        guard let url = URL(string: appStoreOpenUrlString) else {
            print("invalid app store url")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func setupInfoView() {
        view.backgroundColor = .backgroundColor
        
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
        
        let size: CGFloat = 120
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
    
    private func setupVersionLabel() {
        versionLabel = UILabel()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.numberOfLines = 0
        
        versionLabel.text = "현재 버전 : \(BaseData.shared.currentVersion)\n최신 버전 : \(BaseData.shared.lastetVersion)"
        versionLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        
        let width = min(view.frame.width - 80, 800)
        view.addSubview(updateButton)
        updateButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
