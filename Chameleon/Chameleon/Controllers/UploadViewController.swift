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
    var guideLabel: UILabel!
    var uploadView: UIImageView!
    var uploadImageView: UIImageView!
    var uploadLabel: UILabel!
    var uploadButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUploadUI()
        
        setupImagePicker()
        
        uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedUploadView(sender:)))
        uploadView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Actions
    @objc private func clickedUpload(sender: UIButton) {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.guideString = "Loading"
        
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
        let message = "앨범 접근이 거부 되었습니다.\n해당 기능을 사용하시려면 설정에서 권한을 허용해 주세요."
        showTwoButtonAlert(title: "권한 거부됨", message: message, defaultButtonTitle: "권한 설정으로 이동하기", cancelButtonTitle: "취소", defaultAction: { action in
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
    
    //MARK: - Setup
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        if UploadInfo.shared.uploadType == .Photo {
            imagePicker.mediaTypes = ["public.image"]
        } else {
            imagePicker.mediaTypes = ["public.movie"]
        }
        
        imagePicker.delegate = self
    }
    
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
        uploadImageView.isUserInteractionEnabled = false
        
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
        uploadLabel.isUserInteractionEnabled = false
        
        uploadLabel.text = "Choose \(UploadInfo.shared.uploadType)"
        uploadLabel.textColor = .lightGray
        
        uploadView.addSubview(uploadLabel)
        uploadLabel.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
        uploadLabel.topAnchor.constraint(equalTo: uploadImageView.bottomAnchor, constant: 10).isActive = true
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) {
            if UploadInfo.shared.uploadType == .Photo {
                if let image = info[.originalImage] as? UIImage,
                   let assetPath = info[.imageURL] as? URL {
                    
                    let URLString = assetPath.absoluteString.lowercased()
                    print("assetPath: \(assetPath) / URLString: \(URLString)")
                    
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
                    
                    var imageFile: ImageFile?
                    switch imageType {
                    case "png":
                        imageFile = ImageFile(filename: "png-test", data: image.pngData(), type: imageType)
                    case "jpg":
                        imageFile = ImageFile(filename: "jpg-test", data: image.jpegData(compressionQuality: 1.0), type: imageType)
                    case "jpeg":
                        imageFile = ImageFile(filename: "jpeg-test", data: image.jpegData(compressionQuality: 1.0), type: imageType)
                    default: break
                    }
                    
                    if let imageFile = imageFile {
                        self.showImage(image)
                        
                        HttpService.shared.uploadImage(params: [:], image: imageFile)
                    }
                }
            } else {
                let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                print("videoURL:\(String(describing: videoURL))")
                
                self.getThumbnailFromUrl(videoURL!.absoluteString) { [weak self] (img) in
                    if let img = img {
                        self?.showImage(img)
                    }
                }
            }
        }
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
    
    func showImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.uploadView.image = image
            
            self.uploadImageView.isHidden = true
            self.uploadLabel.isHidden = true
        }
    }
}

//SampleFaceImage
