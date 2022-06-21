//
//  ResultView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/06/21.
//

import UIKit

final class ResultView: UIView {
    
    //MARK: - Views
    var resultImageView: UIImageView!
    
    var buttonStack: UIStackView!
    var saveButton: UIButton!
    var shareButton: UIButton!
    
    var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = .backgroundColor
        
        setupResultView()
        
        setupButtonStackView()
        setupSaveButton()
        setupShareButton()
        
        setupDoneButton()
    }
    
    private func setupResultView() {
        resultImageView = UIImageView()
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        
        resultImageView.backgroundColor = UIColor.backgroundColor
        resultImageView.contentMode = .scaleAspectFill
        resultImageView.clipsToBounds = true
        resultImageView.layer.borderColor = UIColor.edgeColor.cgColor
        resultImageView.layer.borderWidth = 2
        resultImageView.layer.cornerRadius = 20
        
        self.addSubview(resultImageView)
        let width = min(self.frame.width * 0.8, 600)
        resultImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        resultImageView.heightAnchor.constraint(equalTo: resultImageView.widthAnchor).isActive = true
        resultImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        if width < 600 {
            resultImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        } else {
            resultImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -120).isActive = true
        }
    }
    
    private func setupButtonStackView() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .center
        
        self.addSubview(buttonStack)
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSaveButton() {
        saveButton = createToolButton(title: "저장하기", systemName: "arrow.down.to.line")
        buttonStack.addArrangedSubview(saveButton)
    }
    
    private func setupShareButton() {
        shareButton = createToolButton(title: "공유하기", systemName: "paperplane.fill")
        buttonStack.addArrangedSubview(shareButton)
    }
    
    private func setupDoneButton() {
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.applyMainButtonStyle(title: "종료하기")
        
        let width = min(self.frame.width - 80, 800)
        self.addSubview(doneButton)
        doneButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func createToolButton(title: String, systemName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: CGFloat(24))
        button.setImage(UIImage(systemName: systemName, withConfiguration: imageConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .mainColor
        button.alignTextBelow()
        
        return button
    }
}
