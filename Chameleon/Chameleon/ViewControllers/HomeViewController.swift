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
    lazy var photoButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "ButtonBorderColor")?.cgColor
        view.layer.cornerRadius = 15
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        
        //inner view
        let innerView = UIView()
        view.addSubview(innerView)
        innerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        
        //image
        let imageView = UIImageView()
        if let buttonImage = UIImage(named: "PhotoButton") {
            imageView.image = buttonImage
        }
        
        innerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(49)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        //label
        let textLabel = UILabel()
        textLabel.text = "PHOTO"
        
        innerView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
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
    
    //MARK: - Methods
    private func setUpNavigationBar() {
        navigationItem.title = "Face Swap with Fake Face"
        
        let appearance = UINavigationBarAppearance()
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
        
        view.addSubview(photoButton)
        photoButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width / 2.5)
            make.height.equalTo(self.view.frame.width / 3.5)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(34)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        
    }
}


//MARK: - Preivew
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = HomeViewController
    
    func makeUIViewController(context: Context) -> HomeViewController {
        return HomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ViewControllerRepresentable()
        }
    }
}
