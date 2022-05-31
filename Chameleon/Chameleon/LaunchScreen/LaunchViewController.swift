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
    private var LoadingTime: Double = 2
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HttpService.shared.loadVersion(completionHandler: { [weak self] (result, response) in
            if result {
                self?.setupAppInfo(response: (response as! Response))
                self?.presentNextVC()
            } else {
                self?.showErrorAlert(erorr: "서버 통신에 실패했습니다.", action: { _ in
                    self?.presentNextVC()
                })
            }
        })
    }
    
    override func loadView() {
        super.loadView()
        
        launchView = LaunchView(frame: self.view.frame)
        self.view = launchView
    }
    
    //MARK: - Methods
    private func setupAppInfo(response: Response) {
        BaseData.shared.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        BaseData.shared.lastetVersion = response.message ?? "0.0.0"
        BaseData.shared.forcedUpdateVersion = response.data ?? "0.0.0"

        print("currentVersion: \(BaseData.shared.currentVersion) / lastetVersion: \(BaseData.shared.lastetVersion) / forcedUpdateVersion: \(BaseData.shared.forcedUpdateVersion)")
    }
    
    private func presentNextVC() {
        HttpService.shared.deleteFiles(completionHandler: { _,_ in })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.LoadingTime) {
            let vc: UIViewController = CustomTabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}
