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
    }
    
    private func setUpUploadView() {
        uploadView.backgroundColor = UIColor().backgroundColor()
        
        uploadView.clipsToBounds = true
        uploadView.layer.borderColor = UIColor().edgeColor().cgColor
        uploadView.layer.borderWidth = 2
        uploadView.layer.cornerRadius = 20
        
        view.addSubview(uploadView)
        uploadView.snp.makeConstraints { make in
            make.width.height.equalTo(view.frame.width * 0.6)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
    }
}

enum UploadType: String {
    case Photo
    case Video
}
