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
    var resultURL: String?
    var resultImage: UIImage?
    var isDone: Bool { time >= 100 }
    var time: Int = 0, firstStandTime: Int = 0
    var inTimer: Int = 0
    var timer: Timer?
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCovertUI()
        
        doneButton.addTarget(self, action: #selector(clickedDoneButton(sender:)), for: .touchUpInside)
        
        firstStandTime = Int.random(in: 10...20)
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(progressConvert(sender:)), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    //MARK: - Actions
    @objc private func clickedDoneButton(sender: UIButton) {
        if let resultURL = resultURL {
            LoadingIndicator.showLoading()
            
            DispatchQueue.global().async {
                guard let url = URL(string: resultURL),
                      let data = try? Data(contentsOf: url),
                      let resultImage = UIImage(data: data) else {
                    LoadingIndicator.hideLoading()
                    self.showErrorAlert()
                    return
                }
                
                HttpService.shared.deleteFiles(completionHandler: { _, _ in })

                DispatchQueue.main.async {
                    LoadingIndicator.hideLoading()
                    
                    let resultVC = ResultViewController()
                    resultVC.modalPresentationStyle = .fullScreen
                    resultVC.resultImageURL = resultURL
                    resultVC.resultImage = resultImage
                    
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            }
        } else {
            self.showTwoButtonAlert(message: "얼굴 변환을 중단하시겠습니까?", defaultButtonTitle: "중단하기", cancelButtonTitle: "이어하기", defaultAction: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    //MARK: - Methods
    private func downloadResult() {
        HttpService.shared.downloadResultFile() { [weak self] (result, response) in
            guard let self = self else { return }
            guard result, let response = response as? Response,
                  let resultURL = response.data else {
                return
            }
            
            self.resultURL = resultURL
        }
    }
    
    @objc private func progressConvert(sender: UIProgressView) {
        inTimer += 1
        if let _ = resultURL {
            time += Int.random(in: 10...20)
            
            if time > 100 {
                timer?.invalidate()
                completeConvert()
            }
        } else {
            if time < firstStandTime {
                time += Int.random(in: 3...5)
            } else {
                if inTimer % 10 == 0 { //5초
                    time += Int.random(in: 1...3)
                    time = min(time, 99)
                }
                
                if inTimer % 50 == 0 {
                    inTimer = 0
                    downloadResult()
                }
            }
        }
        
        progressView.setProgress(Float(Double(time) / 100.0), animated: true)
        progressLabel.text = "\(min(time, 100))%"
    }
    
    private func errorEvent() {
        self.showErrorAlert()
    }
    
    private func completeConvert() {
        doneButton.setTitle("결과 보기", for: .normal)
        
        guideLabel.text = "얼굴 변환이 완료되었습니다.\n결과를 확인하세요."
        
        setupNavigationBar(title: "얼굴 변환 완료")
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
        
        let width = min(view.frame.width * 0.6, 500)
        view.addSubview(progressStack)
        progressStack.widthAnchor.constraint(equalToConstant: width).isActive = true
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
        progressView.widthAnchor.constraint(equalTo: progressStack.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "변환 중단")
        
        let width = min(view.frame.width - 80, 800)
        view.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
