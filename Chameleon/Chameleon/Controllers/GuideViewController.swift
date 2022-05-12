//
//  GuideViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/12.
//

import UIKit

class GuideViewController: BaseViewController {

    //MARK: - Views
    private var closeButton: UIButton!
    private var logoImageView: UIImageView!
    private var guideLabel: UILabel!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGuideUI()
        
        closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - Methods
    private func setupGuideUI() {
        view.backgroundColor = .backgroundColor
        
        setupCloseButton()
        setupLogoImageView()
        setupGuideLabel()
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("닫기", for: .normal)
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupLogoImageView() {
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.image = UIImage(named: "LogoImage")
        logoImageView.contentMode = .scaleAspectFit
        
        view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 320).isActive = true
        logoImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupGuideLabel() {
        
    }
}
