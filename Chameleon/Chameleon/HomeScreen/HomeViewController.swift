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
        
        if BaseData.shared.isNeedForcedUpdate { //강제 업데이트가 필요하면 Alert
            showForcedUpdateAlert()
        } else {
            //홈 메뉴를 누르면 색이 변경되는 이벤트 등록
            homeView.photoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
            homeView.photoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
            homeView.photoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
            
            homeView.videoButton.addTarget(self, action: #selector(touchDownButton(sender:)), for: .touchDown)
            homeView.videoButton.addTarget(self, action: #selector(touchUpInsideButton(sender:)), for: .touchUpInside)
            homeView.videoButton.addTarget(self, action: #selector(touchUpOutsideButton(sender:)), for: .touchUpOutside)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        homeView = HomeView(frame: self.view.frame,
                            tabbarHeight: self.tabBarController!.tabBar.frame.size.height,
                            tabbarPadding: self.tabBarController!.tabBar.safeAreaInsets.bottom)
        self.view = homeView
    }
    
    //MARK: - Actions
    @objc func touchDownButton(sender: HomeMenuButton) {
        sender.touchDown()
    }
    
    @objc func touchUpInsideButton(sender: HomeMenuButton) {
        sender.touchUp()
        UploadData.shared.uploadType = (sender.name == "PHOTO") ? UploadType.Photo : UploadType.Video
        
        //사진 업로드 화면으로 이동
        let uploadVC = UploadViewController()
        uploadVC.modalPresentationStyle = .fullScreen
        uploadVC.hidesBottomBarWhenPushed = true //탭바 숨기기
        navigationController?.pushViewController(uploadVC, animated: true)
    }
    
    @objc func touchUpOutsideButton(sender: HomeMenuButton) {
        sender.touchUp()
    }
    
    //MARK: - Methods
    private func showForcedUpdateAlert() {
        showOneButtonAlert(title: "업데이트 필요", message: "새로운 버전으로 업데이트가 필요합니다.\n확인을 누르면 앱스토어로 이동합니다.", buttonTitle: "확인", action: { _ in
            let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(BaseData.shared.appleID)"
            guard let url = URL(string: appStoreOpenUrlString) else {
                print("invalid app store url")
                return
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
    }
}
