//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Views
    var buttonStack: UIStackView!
    var photoButton: HomeMenuButton!
    var videoButton: HomeMenuButton!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHomeUI()
        
        photoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        photoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
        videoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        videoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
    }
    
    //MARK: - Actions
    @objc func touchDownButton(sender: HomeMenuButton) {
        sender.touchDown()
    }
    
    @objc func touchUpInsideButton(sender: HomeMenuButton) {
        sender.touchUp()
        
        let uploadVC = UploadViewController()
        
        if sender == photoButton {
            UploadInfo.shared.uploadType = .Photo
        } else {
            UploadInfo.shared.uploadType = .Video
        }
        
        uploadVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @objc func touchUpOutsideButton(sender: HomeMenuButton) {
        sender.touchUp()
    }
    
    //MARK: - Setup
    private func setupHomeUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "")

        setupButtonStack()
    }
    
    private func setupButtonStack() {
        buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        
        setupPhotoButton()
        setupVideoButton()
        
        view.addSubview(buttonStack)
        let width = view.frame.width * 0.8
        buttonStack.widthAnchor.constraint(equalToConstant: width).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: width * 0.35).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
    }
    
    private func setupPhotoButton() {
        photoButton = HomeMenuButton(imageName: "PhotoButton", name: "PHOTO")
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(photoButton)
        photoButton.heightAnchor.constraint(equalTo: buttonStack.heightAnchor).isActive = true
    }
    
    private func setupVideoButton() {
        videoButton = HomeMenuButton(imageName: "VideoButton", name: "VIDEO")
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(videoButton)
        videoButton.heightAnchor.constraint(equalTo: buttonStack.heightAnchor).isActive = true
    }
}


//MARK: - Preivew
//import SwiftUI
//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//    typealias UIViewControllerType = HomeViewController
//
//    func makeUIViewController(context: Context) -> HomeViewController {
//        return HomeViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
//
//    }
//}
//
//@available(iOS 13.0.0, *)
//struct ViewPreview: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ViewControllerRepresentable()
//        }
//    }
//}
