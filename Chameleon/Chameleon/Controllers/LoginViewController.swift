//
//  LoginViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

class LoginViewController: BaseViewController {
    
    //MARK: - Views
    var titleImage: UIImageView!
    var textFieldStack: UIStackView!
    var emailTextField: UITextField!
    var pwTextField: UITextField!
    var pwCheckTextField: UITextField!

    var autoLoginButton: UIButton!
    var signUpGuideLabel: UILabel!
    
    var buttonStack: UIStackView!
    var loginButton: UIButton!
    var signUpButton: UIButton!
    var cancelButton: UIButton!
    
    var startSignUpButton: UIButton!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginUI()
        
        self.emailTextField.delegate = self
        self.pwTextField.delegate = self
        self.pwCheckTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(clickedLogin(sender:)), for: .touchUpInside)
        startSignUpButton.addTarget(self, action: #selector(clickedStartSignUpButton(sender:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(clickedDone(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickedCancel(sender:)), for: .touchUpInside)
        autoLoginButton.addTarget(self, action: #selector(clickedAutoLogin(sender:)), for: .touchUpInside)
        
        emailTextField.addTarget(self, action: #selector(changedTextField(sender:)), for: .editingChanged)
        pwTextField.addTarget(self, action: #selector(changedTextField(sender:)), for: .editingChanged)
        pwCheckTextField.addTarget(self, action: #selector(changedTextField(sender:)), for: .editingChanged)

        loginButton.isEnabled = false
        signUpButton.isEnabled = false
        
        changeLayout(isLogin: true)
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
    @objc private func changedTextField(sender: UITextField) {
        if isValidEmail() && isValidPassword() && isValidPasswordCheck() {
            loginButton.isEnabled = true
            signUpButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
            signUpButton.isEnabled = false
        }
    }
    
    @objc private func clickedLogin(sender: UIButton) {
        guard let email = emailTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        loginButton.isEnabled = false
        
        FirebaseService.shared.login(withEmail: email, password: password, completion: { [weak self] (authResult, error) in
            self?.loginButton.isEnabled = true
            
            if error == nil {
                if let _ = self?.autoLoginButton.isSelected {
                    self?.saveAuth(email: email, password: password)
                }
                
                self?.clearTextFields()
                
                let homeVC = CustomTabBarController()
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                self?.present(homeVC, animated: true, completion: nil)
            } else {
                print("Login Error: \(String(describing: error))")
                self?.showFailedLoginAlert()
            }
        })
    }
    
    @objc private func clickedStartSignUpButton(sender: UIButton) {
        changeLayout(isLogin: false)
    }
    
    @objc private func clickedDone(sender: UIButton) {
        guard let email = emailTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        guard let password2 = pwCheckTextField.text, password == password2 else {
            showOneButtonAlert(title: "회원가입 실패", message: "비밀번호가 일치하지 않습니다.\n다시 확인해 주세요.")
            return
        }
        
        signUpButton.isEnabled = false
        
        FirebaseService.shared.signUp(withEmail: email, password: password, completion: { [weak self] (authResult, error) in
            self?.signUpButton.isEnabled = true
            guard let user = authResult?.user else {
                self?.showOneButtonAlert(title: "회원가입 실패", message: "이미 존재하는 이메일입니다.\n다른 이메일로 다시 시도해 주세요.")
                return
            }
        
            if let error = error { //에러
                self?.showOneButtonAlert(title: "회원가입 실패", message: "Error(\(error.localizedDescription))가 발생했습니다.\n다시 시도해 주세요.")
            } else {
                self?.changeLayout(isLogin: true)
                self?.showSuccessSignUpAlert()
                
                FirebaseService.shared.addUser(user)
            }
        })
    }
    
    @objc private func clickedCancel(sender: UIButton) {
        changeLayout(isLogin: true)
    }
    
    @objc private func clickedAutoLogin(sender: UIButton) {
        autoLoginButton.isSelected = !autoLoginButton.isSelected
        UserDefaults.standard.set(autoLoginButton.isSelected, forKey: "isSaveAuth")
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Methods
    private func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let preicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return preicate.evaluate(with: emailTextField.text ?? "")
    }
    
    private func isValidPassword() -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,50}" // 8자리 ~ 50자리 영어+숫자
//        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        let preicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return preicate.evaluate(with: pwTextField.text ?? "")
    }
    
    private func isValidPasswordCheck() -> Bool {
        if pwCheckTextField.isHidden {
            return true
        }
        
        guard let pw = pwTextField.text,
              let pwCheck = pwCheckTextField.text else {
            return false
        }
        
        return pw == pwCheck
    }
    
    private func showFailedLoginAlert() {
        showOneButtonAlert(title: "로그인 실패", message: "이메일이나 비밀번호가 틀립니다.")
    }
    
    private func showSuccessSignUpAlert() {
        showOneButtonAlert(title: "회원가입 성공", message: "가입한 정보로 로그인을 해주세요.")
    }
    
    private func saveAuth(email: String, password: String) {
        print("Save Auth!!!")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    private func changeLayout(isLogin: Bool) {
        loginButton.isEnabled = false
        signUpButton.isEnabled = false
        self.clearTextFields()
        
        //sign up UI
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.pwCheckTextField.isHidden = isLogin
        })
        self.signUpGuideLabel.isHidden = isLogin
        self.signUpButton.isHidden = isLogin
        self.cancelButton.isHidden = isLogin
        
        //login UI
        self.autoLoginButton.isHidden = !isLogin
        self.startSignUpButton.isHidden = !isLogin
        self.loginButton.isHidden = !isLogin
        
        if isLogin {
            pwTextField.returnKeyType = .done
        } else {
            pwTextField.returnKeyType = .next
        }
        
        self.emailTextField.becomeFirstResponder()
    }
    
    private func clearTextFields() {
        emailTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
    }
    
    //MARK: - Setup
    private func setupLoginUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupTitleImage()
        
        setupTextFieldStack()
        setupEmailTextField()
        setupPwTextField()
        setupPwCheckTextField()
        
        setupAutoLoginButton()
        
        setupSignUpGuideLabel()
        
        setupButtonStack()
        setupLoginButton()
        setupDoneButton()
        setupCancelButton()
        
        setupStartSignUpButton()
    }
    
    private func setupSignUpGuideLabel() {
        signUpGuideLabel = UILabel()
        signUpGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        signUpGuideLabel.text = "* 비밀번호는 8~50자의 알파벳, 숫자의 조합입니다."
        signUpGuideLabel.font = .systemFont(ofSize: 14)
        signUpGuideLabel.textColor = .lightGray
        signUpGuideLabel.numberOfLines = 0
        
        view.addSubview(signUpGuideLabel)
        signUpGuideLabel.widthAnchor.constraint(equalTo: textFieldStack.widthAnchor).isActive = true
        signUpGuideLabel.leftAnchor.constraint(equalTo: textFieldStack.leftAnchor).isActive = true
        signUpGuideLabel.topAnchor.constraint(equalTo: textFieldStack.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupTextFieldStack() {
        textFieldStack = UIStackView()
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldStack.axis = .vertical
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = 30
        textFieldStack.alignment = .leading
        
        view.addSubview(textFieldStack)
        textFieldStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -160).isActive = true
        textFieldStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldStack.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 40).isActive = true
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
        
        textFieldStack.addArrangedSubview(autoLoginButton)
    }
    
    private func setupStartSignUpButton() {
        startSignUpButton = UIButton(type: .system)
        startSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        startSignUpButton.setTitle("아직 회원이 아니신가요?", for: .normal)
        startSignUpButton.setTitleColor(.lightGray, for: .normal)

        view.addSubview(startSignUpButton)
        startSignUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startSignUpButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
    }
    
    private func setupTitleImage() {
        titleImage = UIImageView()
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        
        titleImage.image = UIImage(named: "LogoImage")
        titleImage.contentMode = .scaleAspectFit
        
        view.addSubview(titleImage)
        titleImage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.1).isActive = true
        titleImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        titleImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupEmailTextField() {
        emailTextField = UnderLineTextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.placeholder = "email"
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        
        textFieldStack.addArrangedSubview(emailTextField)
        emailTextField.widthAnchor.constraint(equalTo: emailTextField.superview!.widthAnchor).isActive = true
    }
    
    private func setupPwTextField() {
        pwTextField = UnderLineTextField()
        pwTextField.translatesAutoresizingMaskIntoConstraints = false
        
        pwTextField.placeholder = "password"
        pwTextField.clearButtonMode = .whileEditing
        pwTextField.isSecureTextEntry = true
        pwTextField.returnKeyType = .done
        
        textFieldStack.addArrangedSubview(pwTextField)
        pwTextField.widthAnchor.constraint(equalTo: pwTextField.superview!.widthAnchor).isActive = true
    }
    
    private func setupPwCheckTextField() {
        pwCheckTextField = UnderLineTextField()
        pwCheckTextField.translatesAutoresizingMaskIntoConstraints = false
        
        pwCheckTextField.placeholder = "check password"
        pwCheckTextField.clearButtonMode = .whileEditing
        pwCheckTextField.isSecureTextEntry = true
        pwCheckTextField.isHidden = true
        pwCheckTextField.returnKeyType = .done
        
        textFieldStack.addArrangedSubview(pwCheckTextField)
        pwCheckTextField.widthAnchor.constraint(equalTo: pwCheckTextField.superview!.widthAnchor).isActive = true
    }
    
    private func setupButtonStack() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 15
        
        view.addSubview(buttonStack)
        buttonStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupDoneButton() {
        signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.applyMainButtonStyle(title: "회원가입")
        
        signUpButton.isHidden = true
        
        buttonStack.addArrangedSubview(signUpButton)
        signUpButton.widthAnchor.constraint(equalTo: signUpButton.superview!.widthAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupCancelButton() {
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.applyMainButtonStyle(title: "취소")
        cancelButton.setBackgroundColor(.lightGray, for: .normal)
        cancelButton.setBackgroundColor(.darkGray, for: .selected)
        
        cancelButton.isHidden = true
        
        buttonStack.addArrangedSubview(cancelButton)
        cancelButton.widthAnchor.constraint(equalTo: cancelButton.superview!.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupLoginButton() {
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.applyMainButtonStyle(title: "로그인")
        
        buttonStack.addArrangedSubview(loginButton)
        loginButton.widthAnchor.constraint(equalTo: loginButton.superview!.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailTextField:
            pwTextField.becomeFirstResponder()
        case self.pwTextField:
            if textField.returnKeyType == .done {
                self.view.endEditing(true)
            } else {
                pwCheckTextField.becomeFirstResponder()
            }
        default: self.view.endEditing(true)
        }
        
        return false
    }
}

extension LoginViewController {
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
            self.startSignUpButton.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
        } else {
            self.buttonStack.transform = .identity
            self.startSignUpButton.transform = .identity
        }
    }
}
