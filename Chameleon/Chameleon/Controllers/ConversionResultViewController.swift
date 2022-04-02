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
//        showThreeButtonAlert(title: "알림", message: message, defaultButtonTitle: "저장하고 나가기", cancelButtonTitle: "취소", destructiveButtonTitle: "저장하지 않고 나가기", defaultAction: defaultAction, destructiveAction: destructiveAction)
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
        
        guideLabel.text = "변환된 \(UploadInfo.shared.uploadTypeString)을 저장하고 공유해 보세요."
        guideLabel.textAlignment = .center
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func setupResultView() {
        resultView = UIView()
        
        resultView.backgroundColor = UIColor.backgroundColor
        
        resultView.clipsToBounds = true
        resultView.layer.borderColor = UIColor.edgeColor.cgColor
        resultView.layer.borderWidth = 2
        resultView.layer.cornerRadius = 20
        
        view.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.height.equalTo(resultView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
    
    private func setupButtonStackView() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints({ make in
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.top.equalTo(resultView.snp.bottom).offset(20)
        })
    }
    
    private func setupSaveButton() {
        saveButton = UIButton(type: .custom)
        
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
        
        doneButton.applyMainButtonStyle(title: "종료하기")
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}
