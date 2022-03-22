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
    lazy var photoButton: UIView = {
        let view = menuView()
        
        let innerView = buttonInnerStackView(imageName: "PhotoButton", title: "PHOTO")
        view.addSubview(innerView)
        innerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
        
        let clickButton = UIButton()
        clickButton.addTarget(self, action: #selector(touchDownPhotoButton(sender:)), for: .touchDown)
        clickButton.addTarget(self, action: #selector(touchUpPhotoButton(sender:)), for: .touchUpInside)
        
        view.addSubview(clickButton)
        clickButton.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        return view
    }()
    
    lazy var videoButton: UIView = {
        let view = menuView()
        
        let innerView = buttonInnerStackView(imageName: "VideoButton", title: "VIDEO")
        view.addSubview(innerView)
        innerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(8)
        }
        
        let clickButton = UIButton()
        clickButton.addTarget(self, action: #selector(touchDownVideoButton(sender:)), for: .touchDown)
        clickButton.addTarget(self, action: #selector(touchUpVideoButton(sender:)), for: .touchUpInside)
        
        view.addSubview(clickButton)
        clickButton.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        return view
    }()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpNavigationBar()
        setUpHomeUI()
    }
    
    //MARK: - Actions
    @objc func touchDownPhotoButton(sender: UIButton) {
        photoButton.backgroundColor = UIColor(named: "MainColor")
        changeSubviewsColor(view: photoButton, color: .white)
    }
    
    @objc func touchUpPhotoButton(sender: UIButton) {
        photoButton.backgroundColor = .white
        changeSubviewsColor(view: photoButton, color: .black)
    }
    
    @objc func touchDownVideoButton(sender: UIButton) {
        videoButton.backgroundColor = UIColor(named: "MainColor")
        changeSubviewsColor(view: videoButton, color: .white)
    }
    
    
    @objc func touchUpVideoButton(sender: UIButton) {
        videoButton.backgroundColor = .white
        changeSubviewsColor(view: videoButton, color: .black)
    }
    
    //MARK: - Methods
    private func changeSubviewsColor(view: UIView, color: UIColor) {
        for v in view.subviews {
            if v is UIStackView {
                let currentStackView = v as! UIStackView
                for sv in currentStackView.subviews {
                    if sv is UILabel {
                        let currnetLabel = sv as! UILabel
                        currnetLabel.textColor = color
                    } else if sv is UIImageView {
                        let currnetImageView = sv as! UIImageView
                        currnetImageView.tintColor = color
                    }
                }
            }
        }
    }
    
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
        
        let buttonView = UIStackView(arrangedSubviews: [photoButton, videoButton])
        buttonView.axis = .horizontal
        buttonView.spacing = 20
        buttonView.alignment = .center
        buttonView.distribution = .fillEqually
        
        view.addSubview(buttonView)
        
        buttonView.snp.makeConstraints { make in
            let width = view.frame.width * 0.8
            make.width.equalTo(width)
            make.height.equalTo(width * 0.35)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        buttonView.addSubview(photoButton)
        buttonView.addSubview(videoButton)

        photoButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
        }
        
        videoButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
    
    private func buttonInnerStackView(imageName: String, title: String) -> UIStackView {
        //inner view
        let imageView = UIImageView()
        let textLabel = UILabel()
        let innerStackView = UIStackView(arrangedSubviews: [imageView, textLabel])

        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.axis = .vertical
        innerStackView.spacing = 15
        innerStackView.distribution = .fill
        innerStackView.alignment = .center
        
        //image
        if let buttonImage = UIImage(named: imageName) {
            imageView.image = buttonImage.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .black
        }
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        //label
        textLabel.text = title
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        return innerStackView
    }
    
    private func menuView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "ButtonBorderColor")?.cgColor
        view.layer.cornerRadius = 15
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        
        return view
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
