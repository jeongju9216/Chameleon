//
//  UplaodView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

final class UploadView: UIView {

    //MARK: - Views
    var uploadImageView: UIImageView! //선택한 이미지 들어가는 View
    var uploadIcon: UIImageView! //uploadImageView 내부 아이콘
    var uploadLabel: UILabel! //uploadImageView 내부 label
    var segmentedControl: UISegmentedControl! //변환 모드 선택하는 segmentedControl
    var segmentedControlLabel: UILabel! //segmentedControl 설명 label
    var uploadButton: UIButton! //완료 버튼
    
    //MARK: - Properties
    private var segmentGuideText: String {
        var message = ""
        switch UploadData.shared.convertType {
        case ConvertType.face.rawValue:
            message = "얼굴을 페이크 얼굴로 변환합니다."
        case ConvertType.mosaic.rawValue:
            message = "얼굴을 모자이크 합니다."
        case ConvertType.all.rawValue:
            message = "얼굴을 페이크 얼굴로 변환하고 모자이크 합니다."
        default: break
        }
        
        return message
    }
    
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
    func showThumbnail(_ image: UIImage) {
        self.uploadImageView.image = image
        
        self.uploadIcon.isHidden = true
        self.uploadLabel.isHidden = true
        
        self.uploadButton.isEnabled = true
    }
    
    func changeSegmentGuideText() {
        segmentedControlLabel.text = segmentGuideText
    }
    
    //MARK: - Setup
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor

        setupUploadImageView()
        setupSegmentedControl()
        setupSegmentedControlLabel()
        setupUploadButton()
    }
    
    private func setupUploadImageView() {
        uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = true
        
        uploadImageView.contentMode = .scaleAspectFill //비율 맞춰서 정사각형으로 채우기
        uploadImageView.backgroundColor = UIColor.backgroundColor
        
        uploadImageView.clipsToBounds = true
        uploadImageView.layer.borderColor = UIColor.edgeColor.cgColor
        uploadImageView.layer.borderWidth = 2
        uploadImageView.layer.cornerRadius = 20
        
        self.addSubview(uploadImageView)
        
        let width = min(self.frame.width * 0.8, 600) //최대 width는 600으로 => 아이패드 대응
        uploadImageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: uploadImageView.widthAnchor).isActive = true
        uploadImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        if width < 600 {
            uploadImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        } else {
            uploadImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -120).isActive = true
        }
        
        setupUploadIcon()
        setupUploadLabel()
    }
    
    private func setupUploadIcon() {
        uploadIcon = UIImageView()
        uploadIcon.translatesAutoresizingMaskIntoConstraints = false
        uploadIcon.isUserInteractionEnabled = false
        
        let uploadImageName: String = (UploadData.shared.uploadType == .Photo) ? "photo" : "video"
        if let uploadImage = UIImage(systemName: uploadImageName) {
            uploadIcon.image = uploadImage.withRenderingMode(.alwaysTemplate)
            uploadIcon.tintColor = .lightGray
            
            uploadImageView.addSubview(uploadIcon)
            uploadIcon.widthAnchor.constraint(equalToConstant: uploadImage.size.width * 2.0).isActive = true
            uploadIcon.heightAnchor.constraint(equalToConstant: uploadImage.size.height * 2.0).isActive = true
            uploadIcon.centerXAnchor.constraint(equalTo: uploadImageView.centerXAnchor).isActive = true
            uploadIcon.centerYAnchor.constraint(equalTo: uploadImageView.centerYAnchor, constant: -10).isActive = true
        }
    }
    
    private func setupUploadLabel() {
        uploadLabel = UILabel()
        uploadLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadLabel.isUserInteractionEnabled = false
        
        uploadLabel.text = "Choose \(UploadData.shared.uploadType)"
        uploadLabel.textColor = .lightGray
        
        uploadImageView.addSubview(uploadLabel)
        uploadLabel.centerXAnchor.constraint(equalTo: uploadImageView.centerXAnchor).isActive = true
        uploadLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["페이크 얼굴", "모자이크", "모두"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .mainColor
        //segmentedControl 아이템 글자 속성
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        
        self.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalTo: uploadImageView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 20).isActive = true
    }
    
    //segmentedControl 설명 label
    private func setupSegmentedControlLabel() {
        segmentedControlLabel = UILabel()
        segmentedControlLabel.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControlLabel.text = segmentGuideText
        segmentedControlLabel.textColor = .gray
        segmentedControlLabel.font = UIFont.systemFont(ofSize: 15)
        segmentedControlLabel.numberOfLines = 0
        
        self.addSubview(segmentedControlLabel)
        segmentedControlLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        segmentedControlLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupUploadButton() {
        uploadButton = UIButton(type: .custom)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.isEnabled = false //사진 선택한 후에 활성화
        
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        let width = min(self.frame.width - 80, 800)
        self.addSubview(uploadButton)
        uploadButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
