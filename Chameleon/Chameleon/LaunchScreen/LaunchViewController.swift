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
            print("[loadVersion] result: \(result) / response: \(response)")
            if result {
                self?.setupAppInfo(lastetVersion: (response as! Response).message ?? "0.0.0")
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
    private func setupAppInfo(lastetVersion: String) {
        BaseData.shared.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        BaseData.shared.lastetVersion = lastetVersion

        print("currentVersion: \(BaseData.shared.currentVersion) / lastetVersion: \(BaseData.shared.lastetVersion)")
    }
    
    private func presentNextVC() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.LoadingTime) {
            let vc: UIViewController = CustomTabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}
