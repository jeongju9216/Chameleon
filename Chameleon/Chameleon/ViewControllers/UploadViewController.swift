//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import SnapKit

class UploadViewController: BaseViewController {

    //MARK: - Views
    let uploadView: UIView = UIView()
    let uploadButton: UIButton = UIButton()

    
    //MARK: - Properties
    var uploadType: UploadType = .Video
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpUploadUI()
    }
    
    
    //MARK: - Methods
    private func setUpUploadUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setUpNavigationBar(title: "Upload \(uploadType)")
        setUpUploadView()
        setUpUploadButton()
    }
    
    private func setUpUploadButton() {
        uploadButton.applyMainButtonStyle(title: "업로드")
        
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func setUpUploadView() {
        uploadView.backgroundColor = UIColor().backgroundColor()
        
        uploadView.clipsToBounds = true
        uploadView.layer.borderColor = UIColor().edgeColor().cgColor
        uploadView.layer.borderWidth = 2
        uploadView.layer.cornerRadius = 20
        
        view.addSubview(uploadView)
        uploadView.snp.makeConstraints { make in
            make.height.equalTo(uploadView.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
}

enum UploadType: String {
    case Photo
    case Video
}
