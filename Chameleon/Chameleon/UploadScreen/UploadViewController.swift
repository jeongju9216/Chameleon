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
    private var uploadView: UploadView!
    private var imagePicker: UIImagePickerController!
    
    //MARK: - Properties
    var mediaFile: MediaFile?
    var loadingVC: LoadingViewController!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        HttpService.shared.deleteFiles(completionHandler: { _,_  in })
        
        setupNavigationBar(title: "\(UploadData.shared.uploadType)")

        setupImagePicker()
        
        uploadView.uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
        uploadView.segmentedControl.addTarget(self, action: #selector(changedSegmentedControl(sender:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedUploadView(sender:)))
        uploadView.uploadImageView.addGestureRecognizer(tapGesture)
    }
    
    override func loadView() {
        super.loadView()
        
        uploadView = UploadView(frame: self.view.frame)
        self.view = uploadView
    }
    
    //MARK: - Actions
    @objc private func changedSegmentedControl(sender: UISegmentedControl) {
        print("selected: \(sender.selectedSegmentIndex)")
        
        UploadData.shared.convertType = sender.selectedSegmentIndex
        uploadView.segmentedControlLabel.text = UploadData.shared.convertTypeString
    }
    
    @objc private func clickedUpload(sender: UIButton) {
        guard let mediaFile = mediaFile else {
            showErrorAlert(erorr: "잘못된 파일입니다. 다시 시도해 주세요.")
            return
        }

        loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.guideString = "파일 업로드 중"
        self.present(loadingVC, animated: true)
        
        LoadingIndicator.showLoading()
        HttpService.shared.deleteFiles(completionHandler: { [weak self] (result, response) in
            guard let self = self else { return }
            guard result else { self.errorResult(); return }
            
            HttpService.shared.uploadMedia(params: [:], media: mediaFile, completionHandler: { [weak self] (result, response) in
                guard let self = self else { return }
                guard result else { self.errorResult(); return }
                
                self.loadingVC.guideString = "얼굴 찾는 중"
                HttpService.shared.getFaces(waitingTime: 1, completionHandler: { [weak self] (result, response) in
                    guard let self = self else { return }
                    guard result, let faceResponse = response as? FaceResponse else {
                        self.errorResult()
                        return
                    }
                    
                    DispatchQueue.main.async {
                        LoadingIndicator.hideLoading()
                        self.loadingVC.dismiss(animated: true)
                        
                        self.moveToSelectVC(faceImages: faceResponse.data ?? [])
                    }
                })
            })
        })
    }
    
    @objc private func clickedUploadView(sender: UIImageView) {
        checkPermission() { isGranted in
            if isGranted {
                self.present(self.imagePicker, animated: true)
            } else {
                self.moveToSetting()
            }
        }
    }
    
    //MARK: - Methods
    private func errorResult() {
        HttpService.shared.deleteFiles(completionHandler: { _,_  in })
        
        DispatchQueue.main.async {
            LoadingIndicator.hideLoading()
            self.loadingVC.dismiss(animated: true) {
                self.showErrorAlert()
            }
        }
    }
    
    private func moveToSelectVC(faceImages: [FaceImage]) {
        let selectVC = SelectViewController()
        selectVC.faceImages = faceImages

        selectVC.modalPresentationStyle = .fullScreen
        selectVC.modalTransitionStyle = .crossDissolve

        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    private func moveToSetting() {
        let message = "사진 접근이 거부 되었습니다.\n설정에서 권한을 허용해 주세요."
        showTwoButtonAlert(title: "권한 거부됨", message: message, defaultButtonTitle: "설정으로 이동하기", cancelButtonTitle: "취소", defaultAction: { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
    }
}

//MARK: - UIImagePickerControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            DispatchQueue.main.async {
                if UploadData.shared.uploadType == .Photo {
                    self?.setImageData(info: info)
                } else {
                    self?.setVideoData(info: info)
                }
            }
        }
    }
    
    private func setImageData(info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let assetPath = info[.imageURL] as? URL {
            self.mediaFile = MediaFile(url: assetPath)
            
            let imageData = (self.mediaFile?.extension == "png") ? image.pngData() : image.jpegData(compressionQuality: 1.0)
            if let imageData = imageData {
                self.mediaFile?.data = imageData
                self.uploadView.showThumbnail(image)
            }
        }
    }
    
    private func setVideoData(info: [UIImagePickerController.InfoKey : Any]) {
        let videoURL = info[.mediaURL] as? URL
        
        if let videoURL = videoURL, let videoData = try? Data(contentsOf: videoURL) {
            self.mediaFile = MediaFile(url: videoURL, data: videoData)
            
            self.getThumbnailFromUrl(videoURL.absoluteString) { [weak self] (image) in
                if let image = image {
                    self?.uploadView.showThumbnail(image)
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
}

//MARK: - ImagePicker Permission
extension UploadViewController {
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
    
    private func checkPermission(completionHandler: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined: //아무것도 설정 X
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
                switch status {
                case .authorized, .limited:
                    completionHandler(true)
                case .denied:
                    completionHandler(false)
                default:
                    break
                }
            })
        case .restricted, .denied: //사용자를 통해 권한을 부여 받는 것이 아니지만, 라이브러리 권한에 제한이 생긴 경우. 사진을 얻어 올 수 없음
            completionHandler(false)
        case .authorized, .limited: //모든 사진 허용
            completionHandler(true)
        default:
            completionHandler(false)
        }
    }
}
