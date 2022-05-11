//
//  CovertViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

class ConvertViewController: BaseViewController {

    //MARK: - Views
    var guideLabel: UILabel!
    
    var uploadImageView: UIImageView!
    
    var progressStack: UIStackView!
    var progressLabel: UILabel!
    var progressView: UIProgressView!
    
    var doneButton: UIButton!
    
    //MARK: - Properties
    var time: Float = 0.0
    var timer: Timer?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCovertUI()
        
        doneButton.isHidden = true
        doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(progressConvert(sender:)), userInfo: nil, repeats: true)
    }
    
    //MARK: - Actions
    @objc private func clickedDoneButton(sender: UIButton) {
        let conversionResultVC = ConversionResultViewController()
        conversionResultVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(conversionResultVC, animated: true)
    }
    
    //MARK: - Methods
    @objc private func progressConvert(sender: UIProgressView) {
        time += 0.05

        progressView.setProgress(time, animated: true)
        progressLabel.text = "\(Int(time * 100))%"

        if time >= 1.0 {
            timer?.invalidate()
            completeConvert()
        }
    }
    
    private func completeConvert() {
        doneButton.isHidden = false
        guideLabel.text = "변환이 완료 되었습니다.\n결과를 확인하세요."
        setupNavigationBar(title: "\(UploadInfo.shared.uploadTypeString) 변환 완료")
    }
    
    //MARK: - Setup
    private func setupCovertUI() {
        setupNavigationBar(title: "\(UploadInfo.shared.uploadTypeString) 변환 중")
        view.backgroundColor = .backgroundColor
        
        setupGuideLabel()
        setupUploadView()
        
        setupProgressStack()
        setupProgressLabel()
        setupProgressView()
        
        setupDoneButton()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = "변환이 완료가 되면\n푸시 알림으로 알려드리겠습니다 🦎"
        guideLabel.textAlignment = .center
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func setupUploadView() {
        uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "ChameleonImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        
        uploadImageView.backgroundColor = UIColor.backgroundColor
        
        uploadImageView.clipsToBounds = true
//        uploadImageView.layer.borderColor = UIColor.edgeColor.cgColor
//        uploadImageView.layer.borderWidth = 2
        uploadImageView.layer.cornerRadius = 20
        
        view.addSubview(uploadImageView)
        uploadImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: uploadImageView.widthAnchor).isActive = true
        uploadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadImageView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 20).isActive = true
        uploadImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        uploadImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupProgressStack() {
        progressStack = UIStackView()
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        
        progressStack.axis = .vertical
        progressStack.spacing = 10
        progressStack.alignment = .center
        progressStack.distribution = .fill
        
        view.addSubview(progressStack)
        progressStack.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        progressStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressStack.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 30).isActive = true
    }
    
    private func setupProgressLabel() {
        progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressLabel.text = "0%"
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        progressLabel.textColor = .lightGray
        
        progressStack.addArrangedSubview(progressLabel)
    }
    
    private func setupProgressView() {
        progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 5
        
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .mainColor
        progressView.progress = 0
        
        progressStack.addArrangedSubview(progressView)
        progressView.widthAnchor.constraint(equalTo: progressView.superview!.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "결과 보기")
        
        view.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
