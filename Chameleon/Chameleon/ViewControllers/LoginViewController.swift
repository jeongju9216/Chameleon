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
    let titleImage: UIImageView = UIImageView()
    let textFieldStack: UIStackView = UIStackView()
    let idTextField: UITextField = UnderLineTextField()
    let pwTextField: UITextField = UnderLineTextField()
    let pwCheckTextField: UITextField = UnderLineTextField()

    let buttonStack: UIStackView = UIStackView()
    let loginButton: UIButton = UIButton()
    let doneButton: UIButton = UIButton()
    let cancelButton: UIButton = UIButton()
    
    let signUpButton: UIButton = UIButton(type: .system)
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLoginUI()
        
        loginButton.addTarget(self, action: #selector(clickedLogin(sender:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(clickedSignUp(sender:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(clickedDone(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickedCancel(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotification()
    }
    
    //MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    @objc private func clickedLogin(sender: UIButton) {
        self.dismiss(animated: true, completion: {
            let homeVC = CustomTabBarController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true, completion: nil)
        })
    }
    
    @objc private func clickedSignUp(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = false
        })
        
        signUpButton.isHidden = true
        loginButton.isHidden = true
        
        doneButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @objc private func clickedDone(sender: UIButton) {
        print("\(#fileID) \(#line)-line, \(#function)")
    }
    
    @objc private func clickedCancel(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = true
        })
        
        signUpButton.isHidden = false
        loginButton.isHidden = false
        
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    //MARK: - Methods
    private func setUpLoginUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setUpTitleImage()
        setUpTextFields()
        setUpButtons()
        setUpSignUpButton()
    }
    
    private func setUpSignUpButton() {
        signUpButton.setTitle("아직 회원이 아니신가요?", for: .normal)
        signUpButton.setTitleColor(.lightGray, for: .normal)

        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).offset(-10)
        }
    }
    
    private func setUpTitleImage() {
        titleImage.image = UIImage(named: "LogoImage")
        titleImage.clipsToBounds = true
        titleImage.contentMode = .scaleAspectFit
        
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.width.equalTo(view.frame.width * 0.8)
            make.height.equalTo(view.frame.height * 0.1)
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
        setUpPwCheckTextField()
        
        view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-160)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImage.snp.bottom).offset(40)
        }
    }
    
    private func setUpIdTextField() {
        idTextField.placeholder = "email"
        idTextField.clearButtonMode = .whileEditing
        idTextField.keyboardType = .emailAddress
        
        textFieldStack.addArrangedSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpPwTextField() {
        pwTextField.placeholder = "password"
        pwTextField.clearButtonMode = .whileEditing
        pwTextField.isSecureTextEntry = true
        
        textFieldStack.addArrangedSubview(pwTextField)
        pwTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpPwCheckTextField() {
        pwCheckTextField.placeholder = "check password"
        pwCheckTextField.clearButtonMode = .whileEditing
        pwCheckTextField.isSecureTextEntry = true
        pwCheckTextField.isHidden = true
        
        textFieldStack.addArrangedSubview(pwCheckTextField)
        pwCheckTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpButtons() {
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15
        
        setUpLoginButton()
        setUpDoneButton()
        setUpCancelButton()
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setUpDoneButton() {
        doneButton.clipsToBounds = true
        
        doneButton.setBackgroundColor(UIColor().buttonColor(), for: .normal)
        doneButton.setBackgroundColor(UIColor().buttonClickColor(), for: .selected)
        doneButton.layer.cornerRadius = 10
        doneButton.setTitle("Sign Up", for: .normal)
        
        doneButton.isHidden = true
        
        buttonStack.addArrangedSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setUpCancelButton() {
        cancelButton.clipsToBounds = true
        
        cancelButton.setBackgroundColor(.lightGray, for: .normal)
        cancelButton.setBackgroundColor(.darkGray, for: .selected)
        cancelButton.layer.cornerRadius = 10
        cancelButton.setTitle("Cancel", for: .normal)
        
        cancelButton.isHidden = true
        
        buttonStack.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setUpLoginButton() {
        loginButton.clipsToBounds = true
        
        loginButton.setBackgroundColor(UIColor().buttonColor(), for: .normal)
        loginButton.setBackgroundColor(UIColor().buttonClickColor(), for: .selected)
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Login", for: .normal)
        
        buttonStack.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.buttonStack.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
            self.signUpButton.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.buttonStack.transform = .identity
        self.signUpButton.transform = .identity
    }
}
