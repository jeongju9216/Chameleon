//
//  ProfileViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/11.
//

import UIKit
import PhotosUI

class ProfileViewController: BaseViewController {

    //MARK: - Views
    var guideLabel: UILabel!
//    var profileImageView: UIImageView!
//    var profileImage: UIImage?
//    var smileImage: UIImageView!
//    var profileGuideLabel: UILabel!
    var doneButton: UIButton!
    
    var textFieldStack: UIStackView!
    var nameTextField: UITextField!
    var ageTextField: UITextField!
    var genderTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    //MARK: - Properties
    var isFirst: Bool = true
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileUI()
//        setupImagePicker()
        
        if isFirst {
            doneButton.addTarget(self, action: #selector(clickedDone(sender:)), for: .touchUpInside)
        }
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedUploadView(sender:)))
//        profileImageView.addGestureRecognizer(tapGesture)
        
        if !isFirst {
            nameTextField.text = User.shared.name
            ageTextField.text = User.shared.age
            genderTextField.text = User.shared.gender
        }
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
    @objc private func clickedDone(sender: UIButton) {
        print("\(#fileID) \(#line)-line, \(#function)")
        guard let name = nameTextField.text,
              let age = ageTextField.text,
              let gender = genderTextField.text else {
            return
        }
        
        if name.isEmpty {
            showOneButtonAlert(message: "이름을 입력해 주세요.")
            return
        }
        
        if age.isEmpty {
            showOneButtonAlert(message: "나이를 입력해 주세요.")
            return
        }
        
        if gender.isEmpty {
            showOneButtonAlert(message: "성별을 입력해 주세요.")
            return
        }
        
        print("name: \(name) / age: \(age) / gender: \(gender)")

        print("\(#fileID) \(#line)-line, \(#function)")
        //todo: profile image
//        guard let profileImage = profileImage else {
//            self.showOneButtonAlert(message: "얼굴 사진을 등록해 주세요.")
//            return
//        }
        
        User.shared.setProfile(name: name, age: age, gender: gender, profile: "profileImage")
        FirebaseService.shared.addUser()
        
        let homeVC = CustomTabBarController()
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .crossDissolve
                
        self.present(homeVC, animated: true)
    }
    
    @objc private func clickedUploadView(sender: UIImageView) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined: //아무것도 설정 X
            print("notDetermined")

            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                switch status {
                case .authorized, .limited:
                    print("권한이 부여됨")
                    self.present(self.imagePicker, animated: true)
                case .denied:
                    print("권한이 거부됨")
                    DispatchQueue.main.async {
                        self.moveToSetting()
                    }
                default:
                    print("그 밖의 권한")
                }
            })
        default:
            break
        }

        let status2 = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        print("status2: \(status2)")
        switch status2 {
        case .restricted: //사용자를 통해 권한을 부여 받는 것이 아니지만, 라이브러리 권한에 제한이 생긴 경우. 사진을 얻어 올 수 없음
            print("restricted")
        case .denied: //거부
            print("denied")
            DispatchQueue.main.async {
                self.moveToSetting()
            }
        case .authorized, .limited: //모든 사진 허용
            print("authorized or limited")
            self.present(imagePicker, animated: true)
        default:
            break
        }
    }
    
    //MARK: - Methods
    private func moveToSetting() {
        let message = "앨범 접근이 거부 되었습니다.\n해당 기능을 사용하시려면 설정에서 권한을 허용해 주세요."
        showTwoButtonAlert(title: "권한 거부됨", message: message, defaultButtonTitle: "권한 설정으로 이동하기", cancelButtonTitle: "취소", defaultAction: { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
    }
    
    //MARK: - Setup
    private func setupProfileUI() {
        view.backgroundColor = UIColor.backgroundColor
        if !isFirst {
            self.setupNavigationBar(title: "내 정보")
        }
        
        setupGuideLabel()
//        setupUploadView()
        setupTextFieldStack()
        setupNameTextField()
        setupAgeTextField()
        setupGenderTextField()
        
        if isFirst {
            setupUploadButton()
        }
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        if !isFirst {
            guideLabel.isHidden = true
        }
        
        guideLabel.text = "프로필 정보"
        guideLabel.font = UIFont.boldSystemFont(ofSize: 24)
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
//    private func setupUploadView() {
//        profileImageView = UIImageView()
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.isUserInteractionEnabled = true
//
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.backgroundColor = UIColor.backgroundColor
//
//        profileImageView.clipsToBounds = true
//        profileImageView.layer.borderColor = UIColor.edgeColor.cgColor
//        profileImageView.layer.borderWidth = 2
//        let width = view.frame.width * 0.4
//        profileImageView.layer.cornerRadius = width / 2
//
//        view.addSubview(profileImageView)
//        profileImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
//        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
//        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        profileImageView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 40).isActive = true
//
//        setupUploadImageInView()
//        setupUploadLabelInView()
//    }
//
//    private func setupUploadImageInView() {
//        smileImage = UIImageView()
//        smileImage.translatesAutoresizingMaskIntoConstraints = false
//        smileImage.isUserInteractionEnabled = false
//
//        let smileImageName: String = "ProfileImage"
//        if let image = UIImage(named: smileImageName) {
//            smileImage.image = image.withRenderingMode(.alwaysTemplate)
//            smileImage.tintColor = .lightGray
//            smileImage.alpha = 0.1
//
//            profileImageView.addSubview(smileImage)
//            print("uploadImage.size.width: \(image.size.width)")
//            let width = image.size.width * 0.3
//            smileImage.widthAnchor.constraint(equalToConstant: width).isActive = true
//            smileImage.heightAnchor.constraint(equalTo: smileImage.widthAnchor).isActive = true
//            smileImage.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
//            smileImage.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 5).isActive = true
//        }
//    }
//
//    private func setupUploadLabelInView() {
//        profileGuideLabel = UILabel()
//        profileGuideLabel.translatesAutoresizingMaskIntoConstraints = false
//        profileGuideLabel.isUserInteractionEnabled = false
//
//        profileGuideLabel.text = "얼굴 사진을\n등록하세요"
//        profileGuideLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        profileGuideLabel.textColor = .lightGray
//        profileGuideLabel.numberOfLines = 0
//
//        profileImageView.addSubview(profileGuideLabel)
//        profileGuideLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
//        profileGuideLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//    }
    
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
        textFieldStack.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 40).isActive = true
    }
    
    private func setupNameTextField() {
        nameTextField = UnderLineTextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.placeholder = "이름"
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.returnKeyType = .next
        nameTextField.isEnabled = isFirst
        
        textFieldStack.addArrangedSubview(nameTextField)
        nameTextField.widthAnchor.constraint(equalTo: nameTextField.superview!.widthAnchor).isActive = true
    }
    
    private func setupAgeTextField() {
        ageTextField = UnderLineTextField()
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        ageTextField.placeholder = "나이"
        ageTextField.keyboardType = .numberPad
        ageTextField.clearButtonMode = .whileEditing
        ageTextField.returnKeyType = .next
        ageTextField.isEnabled = isFirst
        
        textFieldStack.addArrangedSubview(ageTextField)
        ageTextField.widthAnchor.constraint(equalTo: ageTextField.superview!.widthAnchor).isActive = true
    }
    
    private func setupGenderTextField() {
        genderTextField = UnderLineTextField()
        genderTextField.translatesAutoresizingMaskIntoConstraints = false
        
        genderTextField.placeholder = "성별"
        genderTextField.clearButtonMode = .whileEditing
        genderTextField.returnKeyType = .next
        genderTextField.isEnabled = isFirst

        textFieldStack.addArrangedSubview(genderTextField)
        genderTextField.widthAnchor.constraint(equalTo: genderTextField.superview!.widthAnchor).isActive = true
    }
    
    
    private func setupUploadButton() {
        doneButton = UIButton(type: .custom)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "완료")
        
        view.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }

    private func setupImagePicker() {
//        imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.allowsEditing = false
//        imagePicker.mediaTypes = ["public.image"]
//
//        imagePicker.delegate = self
    }
}

//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        self.dismiss(animated: true) {
//            if let image = info[.originalImage] as? UIImage {
//                self.profileImage = image
//                self.showImage(image)
//            }
//        }
//    }
//
//    func showImage(_ image: UIImage) {
//        DispatchQueue.main.async {
//            self.profileImageView.image = image
//
//            self.smileImage.isHidden = true
//            self.profileGuideLabel.isHidden = true
//        }
//    }
//}

extension ProfileViewController {
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
            
//            self.textFieldStack.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
//            self.doneButton.transform = CGAffineTransform(translationX: 0.0, y: -(keyboardHeight - view.safeAreaInsets.bottom))
        } else {
//            self.textFieldStack.transform = .identity
//            self.doneButton.transform = .identity
        }
    }
}
