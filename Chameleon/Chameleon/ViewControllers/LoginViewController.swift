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
    let pwTextField: UITextField = UnderLineTextField()

    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginUI()
        
    }
    
    //MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = 30
        
        setUpIdTextField()
        setUpPwTextField()
        
        view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-160)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
    }
    
    private func setUpIdTextField() {
        idTextField.placeholder = "email"
        idTextField.clearButtonMode = .whileEditing
        
        textFieldStack.addArrangedSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpPwTextField() {
        pwTextField.placeholder = "password"
        pwTextField.clearButtonMode = .whileEditing
        
        textFieldStack.addArrangedSubview(pwTextField)
        pwTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
