//
//  LaunchViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/29.
//

import UIKit

class LaunchViewController: BaseViewController {
    
    //MARK: - Views
    var launchView: LaunchView!

    //MARK: - Properties
    private var loadingTime: Double = 1 //런치 스크린 보여주는 시간
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터베이스 추가
        FirebaseService.shared.initDatabase()
        
        //파이어베이스에서 서버 작동 확인
        FirebaseService.shared.checkServer(completionHandler: { [weak self] (result, message) in
            guard let self = self else { return }

            if result {
                //파이어베이스에서 버전 정보 가져옴
                FirebaseService.shared.fetchVersion(completionHandler: { [weak self] (result, versions) in
                    guard let self = self else { return }
                    
                    self.setupAppInfo(lasted: versions[0], forced: versions[1])
                    self.presentNextVC() //버전
                })
            } else {
                self.showErrorAlert(erorr: message.replacingOccurrences(of: "/n", with: "\n"))
            }
        })
    }
    
    override func loadView() {
        super.loadView()
        
        launchView = LaunchView(frame: self.view.frame)
        self.view = launchView
    }
    
    //MARK: - Methods
    private func setupAppInfo(lasted: String, forced: String) {
        BaseData.shared.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        BaseData.shared.lastetVersion = lasted
        BaseData.shared.forcedUpdateVersion = forced

        print("currentVersion: \(BaseData.shared.currentVersion) / lastetVersion: \(BaseData.shared.lastetVersion) / forcedUpdateVersion: \(BaseData.shared.forcedUpdateVersion)")
    }
    
    private func presentNextVC() {
        //loadingTime 뒤에 화면 이동
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.loadingTime) {
            let vc: UIViewController = CustomTabBarController()
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: false, completion: nil)
        }
    }
}
