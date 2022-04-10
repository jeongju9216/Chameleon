//
//  ConversionResultViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

class ConversionResultViewController: BaseViewController {
    
    //MARK: - Views
    var guideLabel: UILabel!
    
    var resultView: UIView!
    
    var buttonStack: UIStackView!
    var saveButton: UIButton!
    var shareButton: UIButton!
    
    var doneButton: UIButton!
    
    //MARK: - Properties
    let buttonSize: Int = 24
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConversionResultUI()
        
        doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedDoneButton(sender: UIButton) {
        let message = "변환된 \(UploadInfo.shared.uploadTypeString)은 종료 후 즉시 폐기되며\n처음부터 다시 진행하셔야 합니다.\n종료하시겠습니까?"
        
        let action: ((UIAlertAction) -> Void) = { action in
            self.goBackHome()
        }
        
        showTwoButtonAlert(message: message, defaultButtonTitle: "종료하기", defaultAction: action)
    }
    
    //MARK: - Methods
    private func goBackHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Setup
    private func setupConversionResultUI() {
        setupNavigationBar(title: "\(UploadInfo.shared.uploadTypeString) 변환 결과")
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .backgroundColor
        
        setupGuideLabel()
        setupResultView()
        
        setupButtonStackView()
        setupSaveButton()
        setupShareButton()
        
        setupDoneButton()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = "변환된 \(UploadInfo.shared.uploadTypeString)을 저장하고 공유해 보세요."
        guideLabel.textAlignment = .center
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func setupResultView() {
        resultView = UIView()
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        resultView.backgroundColor = UIColor.backgroundColor
        
        resultView.clipsToBounds = true
        resultView.layer.borderColor = UIColor.edgeColor.cgColor
        resultView.layer.borderWidth = 2
        resultView.layer.cornerRadius = 20
        
        view.addSubview(resultView)
        resultView.heightAnchor.constraint(equalTo: resultView.widthAnchor).isActive = true
        resultView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20).isActive = true
        resultView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        resultView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupButtonStackView() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        
        view.addSubview(buttonStack)
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSaveButton() {
        saveButton = UIButton(type: .custom)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("저장하기", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(buttonSize))
        saveButton.setImage(UIImage(systemName: "arrow.down.to.line", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        saveButton.tintColor = .mainColor
        saveButton.alignTextBelow()
        
        buttonStack.addArrangedSubview(saveButton)
    }
    
    private func setupShareButton() {
        shareButton = UIButton(type: .custom)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        shareButton.setTitle("공유하기", for: .normal)
        shareButton.setTitleColor(.label, for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(buttonSize))
        shareButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.tintColor = .mainColor
        shareButton.alignTextBelow()
        
        buttonStack.addArrangedSubview(shareButton)
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "종료하기")
        
        view.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
