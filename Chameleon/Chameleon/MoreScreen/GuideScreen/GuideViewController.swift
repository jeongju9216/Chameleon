//
//  GuideViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/12.
//

import UIKit

class GuideViewController: BaseViewController {

    //MARK: - Views
    private var guideView: GuideView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
                
        guideView.closeButton.addTarget(self, action: #selector(clickedCloseButton(sender:)), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        guideView = GuideView(frame: self.view.frame)
        self.view = guideView
    }
    
    //MARK: - Actions
    @objc private func clickedCloseButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
