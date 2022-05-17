//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import PhotosUI
import AVKit
import AVFoundation

class UploadViewController: BaseViewController {
    
    //MARK: - Views
    private var uploadView: UIImageView!
    private var uploadImageView: UIImageView!
    private var uploadLabel: UILabel!
    private var segmentedControl: UISegmentedControl!
    private var segmentedControlLabel: UILabel!
    private var uploadButton: UIButton!
    
    private var imagePicker: UIImagePickerController!
    
    //MARK: - Properties
    var mediaFile: MediaFile?
    var segmentedItem: [String] = ["페이크 얼굴", "모자이크", "모두"]
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUploadUI()
        
        setupImagePicker()
        
        uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(changedSegmentedControl(sender:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedUploadView(sender:)))
        uploadView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Actions
    @objc private func changedSegmentedControl(sender: UISegmentedControl) {
        print("selected: \(sender.selectedSegmentIndex)")
        
        UploadData.shared.convertType = sender.selectedSegmentIndex
        segmentedControlLabel.text = UploadData.shared.convertTypeString
    }
    
    @objc private func clickedUpload(sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.guideString = "얼굴을 찾는 중"
        loadingVC.mediaFile = self.mediaFile
        
        self.present(loadingVC, animated: true)
    }
    
    @objc private func clickedUploadView(sender: UIImageView) {        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined: //아무것도 설정 X
            print("notDetermined")

            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                switch status {
                case .authorized, .limited:
                    print("권한이 부여됨")
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true)
                    }
                case .denied:
                    print("권한이 거부됨")
                    DispatchQueue.main.async {
                        self.moveToSetting()
                    }
                default:
                    print("그 밖의 권한")
                }
            })
        default:
            break
        }

        let status2 = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status2 {
        case .restricted: //사용자를 통해 권한을 부여 받는 것이 아니지만, 라이브러리 권한에 제한이 생긴 경우. 사진을 얻어 올 수 없음
            print("restricted")
        case .denied: //거부
            print("denied")
            DispatchQueue.main.async {
                self.moveToSetting()
            }
        case .authorized, .limited: //모든 사진 허용
            print("authorized or limited")
            self.present(imagePicker, animated: true)
        default:
            break
        }
    }
    
    //MARK: - Methods
    private func moveToSetting() {
        let message = "사진 접근이 거부 되었습니다.\n설정에서 권한을 허용해 주세요."
        showTwoButtonAlert(title: "권한 거부됨", message: message, defaultButtonTitle: "설정으로 이동하기", cancelButtonTitle: "취소", defaultAction: { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
    }
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        if UploadData.shared.uploadType == .Photo {
            imagePicker.mediaTypes = ["public.image"]
        } else {
            imagePicker.mediaTypes = ["public.movie"]
        }
        
        imagePicker.delegate = self
    }
    
    private func setupUploadUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupNavigationBar(title: "\(UploadData.shared.uploadType)")
        setupUploadView()
        setupSegmentedControl()
        setupSegmentedControlLabel()
        setupUploadButton()
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: segmentedItem)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedSegmentTintColor = .mainColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        
        view.addSubview(segmentedControl)
        segmentedControl.widthAnchor.constraint(equalTo: uploadView.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: uploadView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupSegmentedControlLabel() {
        segmentedControlLabel = UILabel()
        segmentedControlLabel.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControlLabel.text = UploadData.shared.convertTypeString
        segmentedControlLabel.textColor = .gray
        segmentedControlLabel.font = UIFont.systemFont(ofSize: 15)
        segmentedControlLabel.numberOfLines = 0
        
        view.addSubview(segmentedControlLabel)
        segmentedControlLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControlLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupUploadButton() {
        uploadButton = UIButton(type: .custom)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.isEnabled = false
        
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        view.addSubview(uploadButton)
        uploadButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -80).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func setupUploadView() {
        uploadView = UIImageView()
        uploadView.translatesAutoresizingMaskIntoConstraints = false
        uploadView.isUserInteractionEnabled = true
        
        uploadView.contentMode = .scaleAspectFill
        uploadView.backgroundColor = UIColor.backgroundColor
        
        uploadView.clipsToBounds = true
        uploadView.layer.borderColor = UIColor.edgeColor.cgColor
        uploadView.layer.borderWidth = 2
        uploadView.layer.cornerRadius = 20
        
        view.addSubview(uploadView)
        
        print("80%: \(view.frame.width * 0.8)")
        let width = min(view.frame.width * 0.8, 600)
        uploadView.widthAnchor.constraint(equalToConstant: width).isActive = true
        uploadView.heightAnchor.constraint(equalTo: uploadView.widthAnchor).isActive = true
        uploadView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if width < 600 {
            uploadView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        } else {
            uploadView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        }
        
        setupUploadImageInView()
        setupUploadLabelInView()
    }
    
    private func setupUploadImageInView() {
        uploadImageView = UIImageView()
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = false
        
        let uploadImageName: String = (UploadData.shared.uploadType == .Photo) ? "photo" : "video"
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
        uploadLabel.isUserInteractionEnabled = false
        
        uploadLabel.text = "Choose \(UploadData.shared.uploadType)"
        uploadLabel.textColor = .lightGray
        
        uploadView.addSubview(uploadLabel)
        uploadLabel.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
        uploadLabel.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10).isActive = true
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if UploadData.shared.uploadType == .Photo {
                self?.setImageData(info: info)
            } else {
                self?.setVideoData(info: info)
            }
        }
    }
    
    private func setImageData(info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let assetPath = info[.imageURL] as? URL {
            
            let (imageType, imageName) = self.parsingImageInfo(url: assetPath)
            let imageData = self.createImageData(image, type: imageType)
            
            if let imageData = imageData {
                self.mediaFile = MediaFile(filename: imageName, data: imageData, type: "image/\(imageType)")
                self.showImage(image)
            }
        }
    }
    
    private func setVideoData(info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        
        if let videoURL = videoURL, let videoData = try? Data(contentsOf: videoURL) {
            let (videoType, videoName) = self.parsingVideoInfo(url: videoURL)
            self.mediaFile = MediaFile(filename: videoName, data: videoData, type: "video/\(videoType)")
            
            self.getThumbnailFromUrl(videoURL.absoluteString) { [weak self] (img) in
                if let img = img {
                    self?.showImage(img)
                }
            }
        }
    }
}

extension UploadViewController {
    private func parsingImageInfo(url: URL) -> (String, String) {
        let URLString = url.absoluteString.lowercased()

        var imageType = "unknown"
        if (URLString.hasSuffix("jpg")) {
            imageType = "jpg"
        } else if (URLString.hasSuffix("jpeg")) {
            imageType = "jpeg"
        } else if (URLString.hasSuffix("png")) {
            imageType = "png"
        } else {
            print("Invalid Type")
        }
        print("imageType: \(imageType)")
        
        let imageName = URLString.components(separatedBy: "/").last ?? (DateUtils.getCurrentDateTime() + ".\(imageType)")

        return (imageType, imageName)
    }
    
    private func createImageData(_ image: UIImage, type: String) -> Data? {
        var imageData: Data?
        switch type {
        case "png":
            imageData = image.pngData()
        case "jpg":
            imageData = image.jpegData(compressionQuality: 1.0)
        case "jpeg":
            imageData = image.jpegData(compressionQuality: 1.0)
        default: break
        }
    
        return imageData
    }
    
    private func parsingVideoInfo(url: URL) -> (String, String) {
        let URLString = url.absoluteString.lowercased()
        
        var videoType = "unknown"
        if (URLString.hasSuffix("mov")) {
            videoType = "mov"
        } else if (URLString.hasSuffix("mp4")) {
            videoType = "mp4"
        } else {
            print("Invalid Type")
        }
        print("videoType: \(videoType)")
        
        let videoName = URLString.components(separatedBy: "/").last ?? (DateUtils.getCurrentDateTime() + ".\(videoType)")
        
        return (videoType, videoName)
    }
    
    private func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {
        guard let url = URL(string: url ?? "") else { return }

        DispatchQueue.global().async {
            let asset = AVAsset(url: url)

            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true

            let time = CMTimeMake(value: 2, timescale: 1)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                completion(thumbnail)
            } catch {
                print("Error :: ", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    private func showImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.uploadView.image = image
            
            self.uploadImageView.isHidden = true
            self.uploadLabel.isHidden = true
            
            self.uploadButton.isEnabled = true            
        }
    }
}
