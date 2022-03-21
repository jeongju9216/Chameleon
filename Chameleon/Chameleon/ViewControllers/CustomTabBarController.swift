//
//  CustomTabBarController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/21.
//

import UIKit
import SnapKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        //commit test
        super.viewDidLoad()
        
        let mainVC = UINavigationController(rootViewController: MainController())
        mainVC.tabBarItem.selectedImage = UIImage(systemName: "message")
        mainVC.tabBarItem.title = "Home"
        mainVC.tabBarItem.image = UIImage(systemName: "message.fill")
        
        let moreVC = UINavigationController(rootViewController: UIViewController())
        moreVC.tabBarItem.title = "More"
        
        self.viewControllers = [mainVC, moreVC]
    }
}
