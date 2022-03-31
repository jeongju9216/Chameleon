//
//  LoginViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: - Views
    let titleImage: UIImageView = UIImageView()
    let textFieldStack: UIStackView = UIStackView()
    let idTextField: UITextField = UnderLineTextField()
    let pwTextField: UITextField = UnderLineTextField()
    let pwCheckTextField: UITextField = UnderLineTextField()

    var autoLoginButton: UIButton!
    var guideLabel: UILabel!
    
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
        signUpButton.addTarget(self, action: #selector(clickedStartSignUpButton(sender:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(clickedDone(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickedCancel(sender:)), for: .touchUpInside)
        autoLoginButton.addTarget(self, action: #selector(clickedAutoLogin(sender:)), for: .touchUpInside)
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
        guard let email = idTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            
            if error == nil {
                if let _ = self?.autoLoginButton.isSelected {
                    strongSelf.saveAuth(email: email, password: password)
                }
                
                let homeVC = CustomTabBarController()
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                strongSelf.present(homeVC, animated: true, completion: nil)
            } else {
                print("Login Error: \(String(describing: error))")
                strongSelf.showWrongLoginGuide()
            }
        }
    }
    
    @objc private func clickedStartSignUpButton(sender: UIButton) {
        showSignUpUI()
    }
    
    @objc private func clickedDone(sender: UIButton) {
        guard let email = idTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                self.showWrongSignUpGuide()
                return
                
            }
            
            if error == nil { //정상 완료
                print("user: \(user)")
                self.showLoginUI()
                self.showLoginGuide()
            } else {
                //에러
                print("Auth Error: \(String(describing: error))")
                self.showWrongSignUpGuide()
            }
        }
    }
    
    @objc private func clickedCancel(sender: UIButton) {
        showLoginUI()
    }
    
    @objc private func clickedAutoLogin(sender: UIButton) {
        autoLoginButton.isSelected = !autoLoginButton.isSelected
        UserDefaults.standard.set(autoLoginButton.isSelected, forKey: "isSaveAuth")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Methods
    private func showWrongLoginGuide() {
        guideLabel.text = "이메일이나 비밀번호가 틀렸습니다."
        guideLabel.textColor = .red
        guideLabel.isHidden = false
    }
    
    private func showWrongSignUpGuide() {
        guideLabel.text = "이미 존재하는 이메일입니다."
        guideLabel.textColor = .red
        guideLabel.isHidden = false
    }
    
    private func showLoginGuide() {
        guideLabel.text = "가입한 계정으로 로그인을 해주세요."
        guideLabel.textColor = .label
        guideLabel.isHidden = false
    }
    
    private func hideGuideLabel() {
        guideLabel.isHidden = true
    }
    
    private func saveAuth(email: String, password: String) {
        print("Save Auth!!!")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    private func showLoginUI() {
        self.clearTextFields()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = true
        })
        
        self.autoLoginButton.isHidden = false
        
        self.signUpButton.isHidden = false
        self.loginButton.isHidden = false
        
        self.doneButton.isHidden = true
        self.cancelButton.isHidden = true
        
        self.idTextField.becomeFirstResponder()
    }
    
    private func showSignUpUI() {
        self.clearTextFields()
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = false
        })
        
        self.autoLoginButton.isHidden = true
        
        self.signUpButton.isHidden = true
        self.loginButton.isHidden = true
        
        self.doneButton.isHidden = false
        self.cancelButton.isHidden = false
        
        self.idTextField.becomeFirstResponder()
    }
    
    private func clearTextFields() {
        idTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
        
        guideLabel.isHidden = true
    }
    
    private func setupLoginUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupTitleImage()
        setupTextFields()
        setupAutoLoginButton()
        setupGuideLabel()
        
        setupButtons()
        setupSignUpButton()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.font = .systemFont(ofSize: 16)
        guideLabel.isHidden = true
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.left.equalTo(textFieldStack.snp.left)
            make.top.equalTo(autoLoginButton.snp.bottom).offset(20)
        }
    }
    
    private func setupAutoLoginButton() {
        autoLoginButton = UIButton(type: .custom)
        autoLoginButton.setTitle("  자동로그인", for: .normal)
        autoLoginButton.setTitleColor(.lightGray, for: .normal)
        autoLoginButton.setImage(UIImage(systemName: "squareshape")?.withRenderingMode(.alwaysTemplate), for: .normal)
        autoLoginButton.setImage(UIImage(systemName: "checkmark.square.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        autoLoginButton.tintColor = .mainColor
        
        let isSaveAuth = UserDefaults.standard.bool(forKey: "isSaveAuth")
        autoLoginButton.isSelected = isSaveAuth
        
        view.addSubview(autoLoginButton)
        autoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldStack.snp.bottom).offset(20)
            make.left.equalTo(textFieldStack.snp.left)
        }
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
        idTextField.autocorrectionType = .no
        idTextField.autocapitalizationType = .none
        
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
//        doneButton.isEnabled = false
        
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
//        loginButton.isEnabled = false
        
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
            
            self.buttonStack.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
            self.signUpButton.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
        } else {
            self.buttonStack.transform = .identity
            self.signUpButton.transform = .identity
        }
    }
}
