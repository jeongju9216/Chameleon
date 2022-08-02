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
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터베이스 추가
        FirebaseService.shared.initDatabase()
        
        //파이어베이스에서 서버 작동 확인
        Task {
            let (isLiveServer, message) = await FirebaseService.shared.checkServer()
            guard isLiveServer else {
                self.showErrorAlert(erorr: message.replacingOccurrences(of: "/n", with: "\n"))
                return
            }
            
            let (lasted, forced) = await FirebaseService.shared.fetchVersion()
            self.setupAppInfo(lasted: lasted, forced: forced)
            self.presentNextVC() //버전
        }
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
        let vc: UIViewController = CustomTabBarController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
