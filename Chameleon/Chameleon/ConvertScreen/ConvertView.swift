//
//  ConvertView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/06/21.
//

import UIKit

final class ConvertView: UIView {
    
    //MARK: - Views
    private var guideLabel: UILabel! //안내 문구 label
    private var chameleonImageView: UIImageView! //카멜레온 imageView
    
    //progress바
    private var progressStack: UIStackView!
    private var progressLabel: UILabel!
    private var progressView: UIProgressView!
    
    var doneButton: UIButton! //완료 버튼
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Methods
    func setCompleteText() {
        doneButton.setTitle("결과 보기", for: .normal)
        guideLabel.text = "얼굴 변환이 완료되었습니다.\n결과를 확인하세요."
    }
    
    //정수형으로 진행률 표시
    func setProgressTime(time: Int) {
        progressView.setProgress(Float(Double(time) / 100.0), animated: true)
        progressLabel.text = "\(min(time, 100))%"
    }
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = .backgroundColor
        
        setupChameleonImageView()
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
        
        self.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        guideLabel.bottomAnchor.constraint(equalTo: chameleonImageView.topAnchor, constant: -40).isActive = true
    }
    
    private func setupChameleonImageView() {
        chameleonImageView = UIImageView()
        chameleonImageView.image = UIImage(named: "ChameleonImage")
        chameleonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(chameleonImageView)
        chameleonImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        chameleonImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        chameleonImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        chameleonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40).isActive = true
    }
    
    private func setupProgressStack() {
        progressStack = UIStackView()
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        
        progressStack.axis = .vertical
        progressStack.spacing = 10
        progressStack.alignment = .center
        progressStack.distribution = .fill
        
        let width = min(self.frame.width * 0.6, 500) //아이패드에서 progressView 너무 길지 않도록 처리
        self.addSubview(progressStack)
        progressStack.widthAnchor.constraint(equalToConstant: width).isActive = true
        progressStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        progressStack.topAnchor.constraint(equalTo: chameleonImageView.bottomAnchor, constant: 20).isActive = true
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
        
        progressView.trackTintColor = .lightGray //채워지지 않은 공간 색 설정
        progressView.progressTintColor = .mainColor //진행률 색 설정
        progressView.progress = 0
        
        progressStack.addArrangedSubview(progressView)
        progressView.widthAnchor.constraint(equalTo: progressStack.widthAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "변환 중단")
        
        let width = min(self.frame.width - 80, 800)
        self.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
