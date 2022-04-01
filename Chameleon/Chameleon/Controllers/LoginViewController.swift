//
//  LoginViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: BaseViewController {
    
    //MARK: - Views
    let titleImage: UIImageView = UIImageView()
    let textFieldStack: UIStackView = UIStackView()
    let idTextField: UITextField = UnderLineTextField()
    let pwTextField: UITextField = UnderLineTextField()
    let pwCheckTextField: UITextField = UnderLineTextField()

    var autoLoginButton: UIButton!
    var signUpGuideLabel: UILabel!
    
    let buttonStack: UIStackView = UIStackView()
    let loginButton: UIButton = UIButton()
    let signUpButton: UIButton = UIButton()
    let cancelButton: UIButton = UIButton()
    
    let startSignUpButton: UIButton = UIButton(type: .system)
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginUI()
        
        loginButton.addTarget(self, action: #selector(clickedLogin(sender:)), for: .touchUpInside)
        startSignUpButton.addTarget(self, action: #selector(clickedStartSignUpButton(sender:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(clickedDone(sender:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickedCancel(sender:)), for: .touchUpInside)
        autoLoginButton.addTarget(self, action: #selector(clickedAutoLogin(sender:)), for: .touchUpInside)
        
        idTextField.addTarget(self, action: #selector(changedTextField(sender:)), for: .editingChanged)
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
        guard let email = idTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        loginButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            strongSelf.loginButton.isEnabled = true
            
            if error == nil {
                if let _ = self?.autoLoginButton.isSelected {
                    strongSelf.saveAuth(email: email, password: password)
                }
                
                self?.clearTextFields()
                
                let homeVC = CustomTabBarController()
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                strongSelf.present(homeVC, animated: true, completion: nil)
            } else {
                print("Login Error: \(String(describing: error))")
                self?.showFailedLoginAlert()
            }
        }
    }
    
    @objc private func clickedStartSignUpButton(sender: UIButton) {
        changeLayout(isLogin: false)
    }
    
    @objc private func clickedDone(sender: UIButton) {
        guard let email = idTextField.text,
              let password = pwTextField.text else {
            return
        }
        
        guard let password2 = pwCheckTextField.text, password == password2 else {
            showOneButtonAlert(title: "회원가입 실패", message: "비밀번호가 일치하지 않습니다.\n다시 확인해 주세요.")
            return
        }
        
        signUpButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            self.signUpButton.isEnabled = true
            guard let user = authResult?.user else {
                self.showOneButtonAlert(title: "회원가입 실패", message: "이미 존재하는 이메일입니다.\n다른 이메일로 다시 시도해 주세요.")
                return
            }
        
            if error == nil { //정상 완료
                print("user: \(user)")
                self.changeLayout(isLogin: true)

                self.showSuccessSignUpAlert()
            } else {
                //에러
                print("Auth Error: \(String(describing: error))")
                self.showOneButtonAlert(title: "회원가입 실패", message: "Error(\(error?.localizedDescription))가 발생했습니다.\n다시 시도해 주세요.")
            }
        }
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
        return preicate.evaluate(with: idTextField.text ?? "")
    }
    
    private func isValidPassword() -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,50}" // 8자리 ~ 50자리 영어+숫자
//        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자
        let preicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return preicate.evaluate(with: pwTextField.text ?? "")
    }
    
    private func isValidPasswordCheck() -> Bool {
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
        
        
        
        self.idTextField.becomeFirstResponder()
    }
    
    private func clearTextFields() {
        idTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
    }
    
    //MARK: - Setup
    private func setupLoginUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupTitleImage()
        setupTextFields()
        setupAutoLoginButton()
        
        setupButtons()
        setupSignUpButton()
        
        setupSignUpGuideLabel()
    }
    
    private func setupSignUpGuideLabel() {
        signUpGuideLabel = UILabel()
        signUpGuideLabel.text = "* 비밀번호는 8~50자의 알파벳, 숫자의 조합입니다."
        signUpGuideLabel.font = .systemFont(ofSize: 14)
        signUpGuideLabel.textColor = .lightGray
        signUpGuideLabel.numberOfLines = 0
        
        view.addSubview(signUpGuideLabel)
        signUpGuideLabel.snp.makeConstraints { make in
            make.width.equalTo(textFieldStack.snp.width)
            make.left.equalTo(textFieldStack.snp.left)
            make.top.equalTo(textFieldStack.snp.bottom).offset(20)
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
        
        textFieldStack.addArrangedSubview(autoLoginButton)
    }
    
    private func setupSignUpButton() {
        startSignUpButton.setTitle("아직 회원이 아니신가요?", for: .normal)
        startSignUpButton.setTitleColor(.lightGray, for: .normal)

        view.addSubview(startSignUpButton)
        startSignUpButton.snp.makeConstraints { make in
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
        textFieldStack.alignment = .leading
        
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
        signUpButton.applyMainButtonStyle(title: "회원가입")
        
        signUpButton.isHidden = true
        
        buttonStack.addArrangedSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
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
