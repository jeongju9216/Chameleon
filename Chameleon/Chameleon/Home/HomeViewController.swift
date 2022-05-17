//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Views
    var homeView: HomeView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupHomeUI()
        
        homeView.photoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        homeView.photoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        homeView.photoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
        
        homeView.videoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
        homeView.videoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
        homeView.videoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
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
        
        let uploadVC = UploadViewController()
        
        if sender == homeView.photoButton {
            UploadData.shared.uploadType = .Photo
        } else {
            UploadData.shared.uploadType = .Video
        }
        
        uploadVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @objc func touchUpOutsideButton(sender: HomeMenuButton) {
        sender.touchUp()
    }
    
    //MARK: - Setup
    private func setupHomeUI() {
        setupNavigationBar(title: "")
    }
}
