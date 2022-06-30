//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import Photos
import PhotosUI

class UploadViewController: BaseViewController {
    
    //MARK: - Views
    private var uploadView: UploadView!
    private var phPicker: PHPickerViewController!
    
    //MARK: - Properties
    var mediaFile: MediaFile? //업로드할 파일
    var loadingVC: LoadingViewController!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UploadData.shared.clearData() //화면 처음 진입하면 공유 데이터 초기화
        setupNavigationBar(title: "\(UploadData.shared.uploadType)")

        setupPHPicker()
        
        uploadView.uploadButton.addTarget(self, action: #selector(clickedUpload(sender:)), for: .touchUpInside)
        uploadView.segmentedControl.addTarget(self, action: #selector(changedSegmentedControl(sender:)), for: .valueChanged)
        
        //imageView에 tapGesture 추가
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
        uploadView.changeSegmentGuideText()
    }
    
    //완료 버튼 click
    @objc private func clickedUpload(sender: UIButton) {
        guard let mediaFile = mediaFile else { //mediaFile이 없는 경우
            showErrorAlert(erorr: "잘못된 파일입니다. 다시 시도해 주세요.")
            return
        }

        //로딩 View 보이기
        loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .fullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        loadingVC.guideString = "파일 업로드 중"
        self.present(loadingVC, animated: true)
        
        //터치 방지
        LoadingIndicator.showLoading()
        //디비에서 이미지 삭제를 한 후 업로드 진행
        HttpService.shared.deleteFiles(completionHandler: { [weak self] (result, response) in
            guard let self = self else { return }
            guard result else { self.errorResult(); return } //result가 true일 때만 다음 로직 실행
            
            //이미지 파일 업로드
            HttpService.shared.uploadMedia(params: [:], media: mediaFile, completionHandler: { [weak self] (result, response) in
                guard let self = self else { return }
                guard result else { self.errorResult(); return } //result가 true일 때만 다음 로직 실행
                
                //업로드가 완료되면 classifier 실행
                self.loadingVC.guideString = "얼굴 찾는 중"
                //3초에 한 번씩 호출하면서 classifier가 완료되었는지 확인함
                HttpService.shared.getFaces(waitingTime: 3, completionHandler: { [weak self] (result, response) in
                    guard let self = self else { return }
                    guard result,
                            let faceResponse = response as? FaceResponse else { //result가 true일 때만 다음 로직 실행
                        self.errorResult()
                        return
                    }
                    
                    //서버에서 얻은 얼굴 데이터
                    let faceImages: [FaceImage] = faceResponse.data ?? []
                    print("faceImages count: \(faceImages.count)")
                    
                    //얼굴 이미지 url을 모두 load하여 UIImage로 변경하고 다음 화면으로 이동함
                    let faceImageList: [UIImage?] = faceImages.map { faceImage in
                        guard let url = URL(string: faceImage.url),
                              let data = try? Data(contentsOf: url) else { return nil }
                        
                        return UIImage(data: data)
                    }
                    print("faceImageList count: \(faceImageList.count)")
                    
                    //얼굴 이미지를 로딩 완료했다면 Select VC로 이동
                    DispatchQueue.main.async {
                        LoadingIndicator.hideLoading()
                        self.loadingVC.dismiss(animated: true)
                        
                        self.moveToSelectVC(faceImages: faceImageList)
                    }
                })
            })
        })
    }
    
    //사진을 선택할 때 권한 체크
    @objc private func clickedUploadView(sender: UIImageView) {
        checkPermission() { isGranted in
            DispatchQueue.main.async {
                if isGranted { //권한 OK
                    self.present(self.phPicker, animated: true)
                    //self.present(self.imagePicker, animated: true)
                } else { //권한 X
                    self.moveToSetting() //설정으로 이동하여 권한 설정하도록
                }
            }
        }
    }
    
    //MARK: - Methods
    private func errorResult() {
        //업로드 후 에러가 발생하면 업로드한 파일 수정
        HttpService.shared.deleteFiles(completionHandler: { _,_  in })
        
        DispatchQueue.main.async {
            LoadingIndicator.hideLoading()
            self.loadingVC.dismiss(animated: true) {
                self.showErrorAlert()
            }
        }
    }
    
    private func moveToSelectVC(faceImages: [UIImage?]) {
        let selectVC = SelectViewController()
        selectVC.faceImages = faceImages //얼굴 이미지를 넘김

        selectVC.modalPresentationStyle = .fullScreen
        selectVC.modalTransitionStyle = .crossDissolve

        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    private func moveToSetting() {
        let message = "사진 접근이 거부 되었습니다.\n설정에서 권한을 허용해 주세요."
        showTwoButtonAlert(title: "권한 거부됨", message: message,
                           defaultButtonTitle: "설정으로 이동하기", cancelButtonTitle: "취소",
                           defaultAction: { action in
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
extension UploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results[0].itemProvider
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        
        itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] (url, error) in
            guard let self = self else { return }
            
            print("url: \(String(describing: url))")
            if let url = url {
                self.mediaFile = MediaFile(url: url)
                
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let self = self else { return }
                    
                    if let image = image as? UIImage {
                        let newImage = image.upOrientationImage()
                        let imageData = (self.mediaFile?.extension == "png") ? newImage?.pngData() : newImage?.jpegData(compressionQuality: 1.0)

                        if let imageData = imageData {
                            self.mediaFile?.data = imageData
                            self.uploadView.showThumbnail(image)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - PHPicker Permission
extension UploadViewController {
    private func setupPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
    }
    
    //앨범 권한 체크 -> 앨범에 이미지 저장
    private func checkPermission(completionHandler: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined: //최초 실행. 아무것도 설정 X
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

extension UIImage {
    //메타데이터 exif의 orientaion을 체크하여 up 방향으로 이미지 회전시키기
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
