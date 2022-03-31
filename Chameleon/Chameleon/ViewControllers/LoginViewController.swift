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
        
        setupLoginUI()
        
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
        
        print("\(#fileID) \(#line)-line, \(#function)")
        removeKeyboardNotification()
    }
    
    //MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    @objc private func clickedLogin(sender: UIButton) {
        let homeVC = CustomTabBarController()
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .crossDissolve
        self.present(homeVC, animated: true, completion: nil)
    }
    
    @objc private func clickedSignUp(sender: UIButton) {
        clearTextFields()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = false
        })
        
        signUpButton.isHidden = true
        loginButton.isHidden = true
        
        doneButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @objc private func clickedDone(sender: UIButton) {
        clearTextFields()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = true
        })
        
        signUpButton.isHidden = false
        loginButton.isHidden = false
        
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc private func clickedCancel(sender: UIButton) {
        clearTextFields()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = true
        })
        
        signUpButton.isHidden = false
        loginButton.isHidden = false
        
        doneButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    //MARK: - Methods
    private func clearTextFields() {
        idTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
    }
    
    private func setupLoginUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setupTitleImage()
        setupTextFields()
        setupButtons()
        setupSignUpButton()
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle("아직 회원이 아니신가요?", for: .normal)
        signUpButton.setTitleColor(.lightGray, for: .normal)

        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginButton.snp.top).offset(-10)
        }
    }
    
    private func setupTitleImage() {
        titleImage.image = UIImage(named: "LogoImage")
        titleImage.contentMode = .scaleAspectFit
        
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height * 0.1)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.right.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(40)
        }
    }
    
    private func setupTextFields() {
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = 30
        
        setupIdTextField()
        setupPwTextField()
        setupPwCheckTextField()
        
        view.addSubview(textFieldStack)
        textFieldStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-160)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImage.snp.bottom).offset(40)
        }
    }
    
    private func setupIdTextField() {
        idTextField.placeholder = "email"
        idTextField.clearButtonMode = .whileEditing
        idTextField.keyboardType = .emailAddress
        
        textFieldStack.addArrangedSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupPwTextField() {
        pwTextField.placeholder = "password"
        pwTextField.clearButtonMode = .whileEditing
        pwTextField.isSecureTextEntry = true
        
        textFieldStack.addArrangedSubview(pwTextField)
        pwTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupPwCheckTextField() {
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
    
    private func setupButtons() {
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15
        
        setupLoginButton()
        setupDoneButton()
        setupCancelButton()
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setupDoneButton() {
        doneButton.applyMainButtonStyle(title: "회원가입")
        
        doneButton.isHidden = true
        
        buttonStack.addArrangedSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setupCancelButton() {
        cancelButton.applyMainButtonStyle(title: "취소")
        cancelButton.setBackgroundColor(.lightGray, for: .normal)
        cancelButton.setBackgroundColor(.darkGray, for: .selected)
        
        cancelButton.isHidden = true
        
        buttonStack.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setupLoginButton() {
        loginButton.applyMainButtonStyle(title: "로그인")
        
        buttonStack.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            print("keyboardHeight: \(keyboardHeight)")
            self.buttonStack.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
            self.signUpButton.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
        } else {
            self.buttonStack.transform = .identity
            self.signUpButton.transform = .identity
        }
    }
}
