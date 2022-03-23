//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    //MARK: - Views
    let photoButton: HomeMenuButton = HomeMenuButton(imageName: "PhotoButton", name: "PHOTO")
    let videoButton: HomeMenuButton = HomeMenuButton(imageName: "VideoButton", name: "VIDEO")
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavigationBar()
        setUpHomeUI()
    }
    
    //MARK: - Actions
    @objc func touchDownPhotoButton(sender: UIButton) {
        photoButton.touchDown()
    }
    
    @objc func touchUpPhotoButton(sender: UIButton) {
        photoButton.touchUp()
    }
    
    @objc func touchDownVideoButton(sender: UIButton) {
        videoButton.touchDown()
    }
    
    @objc func touchUpVideoButton(sender: UIButton) {
        videoButton.touchUp()
    }
    
    //MARK: - Methods
    private func setUpNavigationBar() {
        navigationItem.title = "Face Swap with Fake Face"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowRadius = 5
    }
    
    private func setUpHomeUI() {
        view.backgroundColor = .systemBackground
        
        setUpPhotoButton()
        setUpVideoButton()
        setUpButtonStack()
    }
    
    private func setUpButtonStack() {
        let buttonStack = UIStackView(arrangedSubviews: [photoButton, videoButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            let width = view.frame.width * 0.8
            make.width.equalTo(width)
            make.height.equalTo(width * 0.35)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        buttonStack.addSubview(photoButton)
        buttonStack.addSubview(videoButton)
        
        photoButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
        
        videoButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    private func setUpPhotoButton() {
        photoButton.addTarget(self, action: #selector(touchDownPhotoButton(sender:)), for: .touchDown)
        photoButton.addTarget(self, action: #selector(touchUpPhotoButton(sender:)), for: .touchUpInside)
    }
    
    private func setUpVideoButton() {
        videoButton.addTarget(self, action: #selector(touchDownVideoButton(sender:)), for: .touchDown)
        videoButton.addTarget(self, action: #selector(touchUpVideoButton(sender:)), for: .touchUpInside)
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
