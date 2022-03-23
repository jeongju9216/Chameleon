//
//  LoginViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    //MARK: - Views
    let titleLabel: UILabel = UILabel()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginUI()
    }
    
    //MARK: - Methods
    private func setUpLoginUI() {
        view.backgroundColor = .systemBackground
        
        setUpTitleLabel()
        
        
    }
    
    private func setUpTitleLabel() {
        titleLabel.text = "Swap your face\nwith fake face"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
    }
}
