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
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInfoView()
    }
    
    //MARK: - Actions
    
    //MARK: - Methods
    private func setupInfoView() {
        view.backgroundColor = .backgroundColor
        
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("닫기", for: .normal)
        
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
}
