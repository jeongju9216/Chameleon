//
//  InfoViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/10.
//

import UIKit

class InfoViewController: BaseViewController {
    
    //MARK: - Views
    private var infoView: InfoView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
                
        infoView.closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
        infoView.updateButton.addTarget(self, action: #selector(clickedUpdateButton(sender:)), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        infoView = InfoView(frame: self.view.frame)
        self.view = infoView
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func clickedUpdateButton(sender: UIButton) {
        openAppStore()
    }
    
    //MARK: - Methods
    private func openAppStore() {
        let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(BaseData.shared.appleID)"
        guard let url = URL(string: appStoreOpenUrlString) else {
            print("invalid app store url")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
