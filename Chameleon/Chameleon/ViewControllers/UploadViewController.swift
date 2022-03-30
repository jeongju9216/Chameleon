//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import SnapKit

class UploadViewController: BaseViewController {

    //MARK: - Views
    let guideLabel: UILabel = UILabel()
    
    let uploadView: UIView = UIView()
    let uploadImageView: UIImageView = UIImageView()
    let uploadLabel: UILabel = UILabel()
    
    let uploadButton: UIButton = UIButton()

    
    //MARK: - Properties
    var uploadType: UploadType = .Video
    lazy var uploadTypeString: String = {
        return (uploadType == .Photo) ? "사진" : "영상"
    }()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpUploadUI()
        
        uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func clickedUpload(sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.guideString = "Loading"
        self.present(loadingVC, animated: true)
    }
    
    //MARK: - Methods
    private func setUpUploadUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setUpNavigationBar(title: "\(uploadTypeString) 업로드")
        setUpGuideLabel()
        setUpUploadView()
        setUpUploadButton()
    }
    
    private func setUpGuideLabel() {
        guideLabel.text = "변환할 \(uploadTypeString)을 선택해 주세요."
        guideLabel.numberOfLines = 0
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
    }
    
    private func setUpUploadButton() {
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setUpUploadView() {
        uploadView.backgroundColor = UIColor().backgroundColor()
        
        uploadView.clipsToBounds = true
        uploadView.layer.borderColor = UIColor().edgeColor().cgColor
        uploadView.layer.borderWidth = 2
        uploadView.layer.cornerRadius = 20
        
        view.addSubview(uploadView)
        uploadView.snp.makeConstraints { make in
            make.height.equalTo(uploadView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(guideLabel).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        setUpUploadImageInView()
        setUpUploadLabelInView()
    }
    
    private func setUpUploadImageInView() {
        let uploadImageName: String = (uploadType == .Photo) ? "photo" : "video"
        if let uploadImage = UIImage(systemName: uploadImageName) {
            uploadImageView.image = uploadImage.withRenderingMode(.alwaysTemplate)
            uploadImageView.tintColor = .lightGray
            
            uploadView.addSubview(uploadImageView)
            uploadImageView.snp.makeConstraints { make in
                make.width.equalTo(uploadImage.size.width * 2.0)
                make.height.equalTo(uploadImage.size.height * 2.0)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-10)
            }
        }
    }
    
    private func setUpUploadLabelInView() {
        uploadLabel.text = "Choose \(uploadType)"
        uploadLabel.textColor = .lightGray
        
        uploadView.addSubview(uploadLabel)
        uploadLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(uploadImageView.snp.bottom).offset(10)
        }
    }
}

enum UploadType: String {
    case Photo
    case Video
}
