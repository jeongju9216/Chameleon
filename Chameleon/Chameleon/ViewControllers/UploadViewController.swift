//
//  UploadViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit
import SnapKit

class UploadViewController: UIViewController {

    //MARK: - Views
    var uploadType: UploadType = .Video
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpUploadUI()
    }
    
    
    //MARK: - Methods
    private func setUpUploadUI() {
        view.backgroundColor = UIColor().backgroundColor()
        
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "Upload \(uploadType)"
        self.navigationController?.navigationBar.tintColor = .label
        
    }
}

enum UploadType: String {
    case Photo
    case Video
}
