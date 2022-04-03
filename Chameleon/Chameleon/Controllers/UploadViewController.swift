//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit

class UploadViewController: BaseViewController {

    //MARK: - Views
    var guideLabel: UILabel!
    
    var uploadView: UIView!
    var uploadImageView: UIImageView!
    var uploadLabel: UILabel!
    
    var uploadButton: UIButton!

    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUploadUI()
        
        uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedUpload(sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.guideString = "Loading"
        
        self.present(loadingVC, animated: true)
    }
    
    //MARK: - Methods
    
    //MARK: - Setup
    private func setupUploadUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupNavigationBar(title: "\(UploadInfo.shared.uploadType)")
        setupGuideLabel()
        setupUploadView()
        setupUploadButton()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = "변환할 \(UploadInfo.shared.uploadTypeString)을 선택해 주세요."
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func setupUploadButton() {
        uploadButton = UIButton(type: .custom)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        view.addSubview(uploadButton)
        uploadButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupUploadView() {
        uploadView = UIView()
        uploadView.translatesAutoresizingMaskIntoConstraints = false
        
        uploadView.backgroundColor = UIColor.backgroundColor
        
        uploadView.clipsToBounds = true
        uploadView.layer.borderColor = UIColor.edgeColor.cgColor
        uploadView.layer.borderWidth = 2
        uploadView.layer.cornerRadius = 20
        
        view.addSubview(uploadView)
        uploadView.heightAnchor.constraint(equalTo: uploadView.widthAnchor).isActive = true
        uploadView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadView.topAnchor.constraint(equalTo: guideLabel.topAnchor, constant: 40).isActive = true
        uploadView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        uploadView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        
        setupUploadImageInView()
        setupUploadLabelInView()
    }
    
    private func setupUploadImageInView() {
        uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let uploadImageName: String = (UploadInfo.shared.uploadType == .Photo) ? "photo" : "video"
        if let uploadImage = UIImage(systemName: uploadImageName) {
            uploadImageView.image = uploadImage.withRenderingMode(.alwaysTemplate)
            uploadImageView.tintColor = .lightGray
            
            uploadView.addSubview(uploadImageView)
            uploadImageView.widthAnchor.constraint(equalToConstant: uploadImage.size.width * 2.0).isActive = true
            uploadImageView.heightAnchor.constraint(equalToConstant: uploadImage.size.height * 2.0).isActive = true
            uploadImageView.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
            uploadImageView.centerYAnchor.constraint(equalTo: uploadView.centerYAnchor, constant: -10).isActive = true
        }
    }
    
    private func setupUploadLabelInView() {
        uploadLabel = UILabel()
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        
        uploadLabel.text = "Choose \(UploadInfo.shared.uploadType)"
        uploadLabel.textColor = .lightGray
        
        uploadView.addSubview(uploadLabel)
        uploadLabel.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
        uploadLabel.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10).isActive = true
    }
}
