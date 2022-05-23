//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Views
    private var homeView: HomeView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "")
        
        homeView.photoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        homeView.photoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        homeView.photoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
        
        homeView.videoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        homeView.videoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        homeView.videoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(#fileID) \(#line)-line, \(#function)")
    }
    
    override func loadView() {
        super.loadView()
        
        homeView = HomeView(frame: self.view.frame)
        self.view = homeView
    }
    
    //MARK: - Actions
    @objc func touchDownButton(sender: HomeMenuButton) {
        sender.touchDown()
    }
    
    @objc func touchUpInsideButton(sender: HomeMenuButton) {
        sender.touchUp()
        UploadData.shared.uploadType = (sender.name == "PHOTO") ? UploadType.Photo : UploadType.Video
        
        let uploadVC = UploadViewController()
        uploadVC.modalPresentationStyle = .fullScreen
        uploadVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @objc func touchUpOutsideButton(sender: HomeMenuButton) {
        sender.touchUp()
    }
}
