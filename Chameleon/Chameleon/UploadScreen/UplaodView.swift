//
//  UplaodView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

final class UploadView: UIView {

    //MARK: - Views
    var uploadImageView: UIImageView!
    var uploadIcon: UIImageView!
    var uploadLabel: UILabel!
    var segmentedControl: UISegmentedControl!
    var segmentedControlLabel: UILabel!
    var uploadButton: UIButton!
    
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
        
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.backgroundColor = UIColor.backgroundColor
        
        uploadImageView.clipsToBounds = true
        uploadImageView.layer.borderColor = UIColor.edgeColor.cgColor
        uploadImageView.layer.borderWidth = 2
        uploadImageView.layer.cornerRadius = 20
        
        self.addSubview(uploadImageView)
        
        let width = min(self.frame.width * 0.8, 600)
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
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        
        self.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalTo: uploadImageView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSegmentedControlLabel() {
        segmentedControlLabel = UILabel()
        segmentedControlLabel.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControlLabel.text = UploadData.shared.convertTypeString
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
        uploadButton.isEnabled = false
        
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        self.addSubview(uploadButton)
        uploadButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
}
