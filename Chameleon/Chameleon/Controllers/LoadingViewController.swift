//
//  LoadingViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/30.
//

import UIKit
import Lottie

class LoadingViewController: BaseViewController {
    
    //MARK: - Views
    var guideLabel: UILabel!
    
    var chameleonImageView: UIImageView!
    var topAnimationView: AnimationView!
    var bottomAnimationView: AnimationView!
    
    //MARK: - Properties
    var mediaFile: MediaFile?
    var guideString: String = ""
    var animationName = UITraitCollection.current.userInterfaceStyle == .light ? "bottomImage-Light" : "bottomImage-Dark"
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let uploadVC = getUploadViewController()
        if let uploadVC = uploadVC {
            guard let mediaFile = mediaFile else {
                self.dismiss(animated: true, completion: {
                    uploadVC.showErrorAlert(erorr: "파일이 존재하지 않습니다. 다시 시도해 주세요.")
                })
                return
            }
            
            HttpService.shared.getFaces(completionHandler: { [weak self] (result, response) in
                print("[getFaces] result: \(result) / response: \(response)")

                DispatchQueue.main.async {
                    let faceImages: [FaceImage] = response as? [FaceImage] ?? []

                    let chooseFaceVC = ChooseFaceViewController()
                    chooseFaceVC.faceImages = faceImages

                    chooseFaceVC.modalPresentationStyle = .fullScreen
                    chooseFaceVC.modalTransitionStyle = .crossDissolve

                    self?.dismiss(animated: true, completion: {
                        uploadVC.navigationController?.pushViewController(chooseFaceVC, animated: true)
                    })
                }
            })

//            LoadingIndicator.showLoading()
//
//            HttpService.shared.uploadMedia(params: [:], media: mediaFile, completionHandler: { [weak self] (result, response) in
//                print("[uploadMedia] result: \(result) / response: \(response)")
//                LoadingIndicator.hideLoading()
//
//                var result = true
//                if result {
//                    //get faces
//                    HttpService.shared.getFaces(completionHandler: { [weak self] (result, response) in
//                        print("[getFaces] result: \(result) / response: \(response)")
//
//                        DispatchQueue.main.async {
//                            let faceImages: [FaceImage] = response as? [FaceImage] ?? []
//
//                            let chooseFaceVC = ChooseFaceViewController()
//                            chooseFaceVC.faceImages = faceImages
//
//                            chooseFaceVC.modalPresentationStyle = .fullScreen
//                            chooseFaceVC.modalTransitionStyle = .crossDissolve
//
//                            self?.dismiss(animated: true, completion: {
//                                uploadVC.navigationController?.pushViewController(chooseFaceVC, animated: true)
//                            })
//                        }
//                    })
//                } else {
//                    DispatchQueue.main.async {
//                        self?.dismiss(animated: true, completion: {
//                            uploadVC.showErrorAlert(erorr: "업로드에 실패했습니다. 다시 시도해 주세요.")
//                        })
//                    }
//                }
//
//            })
        } else {
            print("uploadVC is nil")
        }
    }
    
    //MARK: - Methods
    private func getUploadViewController() -> UploadViewController? {
        guard let tvc = self.presentingViewController as? UITabBarController,
           let nvc = tvc.selectedViewController as? UINavigationController,
           let uploadVC = nvc.topViewController as? UploadViewController else {
            return nil
        }
        return uploadVC
    }
    
    private func animationLoadingTimer() {
        var count = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.guideLabel.text = self.guideString + String(repeating: ".", count: count % 3)
            count += 1
        }
        timer.fire()
    }
    
    //MARK: - Setup
    private func setupLoadingUI() {
        view.backgroundColor = UIColor.backgroundColor
        
        setupTopAnimationView()
        setupBottomAnimationView()
        setupChameleonImage()
        setupGuideLabel()
    }
    
    private func setupGuideLabel() {
        guideLabel = UILabel()
        guideLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guideLabel.text = guideString
        guideLabel.font = UIFont.boldSystemFont(ofSize: 32)
        guideLabel.numberOfLines = 0
        
        animationLoadingTimer()
        
        view.addSubview(guideLabel)
        guideLabel.topAnchor.constraint(equalTo: chameleonImageView.bottomAnchor, constant: 10).isActive = true
        guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupChameleonImage() {
        chameleonImageView = UIImageView()
        chameleonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let chameleonImage = UIImage(named: "ChameleonImage") {
            chameleonImageView.image = chameleonImage
            chameleonImageView.contentMode = .scaleAspectFill
            chameleonImageView.layer.allowsEdgeAntialiasing = true
            
            view.addSubview(chameleonImageView)
            chameleonImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            chameleonImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            chameleonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chameleonImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        }
        
    }
    
    private func setupTopAnimationView() {
        topAnimationView = .init(name: animationName)
        topAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        topAnimationView.transform = .init(rotationAngle: .pi)
        
        topAnimationView.contentMode = .scaleAspectFill
        topAnimationView.loopMode = .loop
        topAnimationView.animationSpeed = 0.5
        topAnimationView.backgroundBehavior = .pauseAndRestore
        topAnimationView.play()
        
        view.addSubview(topAnimationView)
        topAnimationView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        topAnimationView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        topAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnimationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
    }
    
    private func setupBottomAnimationView() {
        bottomAnimationView = .init(name: animationName)
        bottomAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomAnimationView.contentMode = .scaleAspectFill
        bottomAnimationView.loopMode = .loop
        bottomAnimationView.animationSpeed = 1.2
        bottomAnimationView.backgroundBehavior = .pauseAndRestore
        bottomAnimationView.play()
        
        view.addSubview(bottomAnimationView)
        bottomAnimationView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        bottomAnimationView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        bottomAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
    }
}
