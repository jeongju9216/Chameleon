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
    let textFieldStack: UIStackView = UIStackView()
    let idTextField: UITextField = UnderLineTextField()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginUI()
        
    }
    
    //MARK: - Methods
    private func setUpLoginUI() {
        view.backgroundColor = .systemBackground
        
        setUpTitleLabel()
        setUpTextFields()
        
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
    
    private func setUpTextFields() {
        setUpIdTextField()
        
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = 20
        
        
        view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-200)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
    }
    
    private func setUpIdTextField() {
        idTextField.placeholder = "email"
        
        textFieldStack.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}
