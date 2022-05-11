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
        
        let customBackButton = UIBarButtonItem(image: UIImage(named: "BackArrowIcon") , style: .plain, target: self, action: #selector(backAction(sender:)))
        customBackButton.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = customBackButton
    }
    
    //MARK: - Actions
    @objc private func backAction(sender: UIBarButtonItem) {
        self.showTwoButtonAlert(title: "경고", message: "얼굴 변환을 중단하시겠습니까?", defaultButtonTitle: "중단하기", cancelButtonTitle: "취소", defaultAction: { _ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc private func clickedDoneButton(sender: UIButton) {
        let conversionResultVC = ConversionResultViewController()
        conversionResultVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(conversionResultVC, animated: true)
    }
    
    //MARK: - Methods
    @objc private func progressConvert(sender: UIProgressView) {
        time += 0.1

        progressView.setProgress(time, animated: true)
        progressLabel.text = "\(Int(time * 100))%"

        if time >= 1.0 {
            timer?.invalidate()
            completeConvert()
        }
    }
    
    private func completeConvert() {
        doneButton.isHidden = false
        guideLabel.text = "얼굴 변환이 완료되었습니다.\n결과를 확인하세요."
        setupNavigationBar(title: "얼굴 변환 완료")
        navigationController?.navigationItem.hidesBackButton = true
    }
    
    //MARK: - Setup
    private func setupCovertUI() {
        setupNavigationBar(title: "얼굴 변환 중")
        view.backgroundColor = .backgroundColor
        
        setupUploadView()
        setupGuideLabel()

        setupProgressStack()
        setupProgressLabel()
        setupProgressView()
        
        setupDoneButton()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = "얼굴 변환이 진행 중입니다.\n잠시만 기다려 주세요."
        guideLabel.font = UIFont.systemFont(ofSize: 18)
        guideLabel.textAlignment = .center
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.bottomAnchor.constraint(equalTo: uploadImageView.topAnchor, constant: -40).isActive = true
    }
    
    private func setupUploadView() {
        uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "ChameleonImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        
        uploadImageView.backgroundColor = UIColor.backgroundColor
        
        uploadImageView.clipsToBounds = true
        uploadImageView.layer.cornerRadius = 20
        
        view.addSubview(uploadImageView)
        uploadImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        uploadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
    }
    
    private func setupProgressStack() {
        progressStack = UIStackView()
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        
        progressStack.axis = .vertical
        progressStack.spacing = 10
        progressStack.alignment = .center
        progressStack.distribution = .fill
        
        view.addSubview(progressStack)
        progressStack.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6).isActive = true
        progressStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressStack.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 20).isActive = true
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
