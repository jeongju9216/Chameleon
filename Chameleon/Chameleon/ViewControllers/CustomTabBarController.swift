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
        super.viewDidLoad()
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        mainVC.tabBarItem.image = UIImage(named: "HomeTabIcon")
        mainVC.tabBarItem.title = "Home"
        
        let moreVC = UINavigationController(rootViewController: MoreViewController())
        moreVC.tabBarItem.image = UIImage(named: "MoreTabIcon")
        moreVC.tabBarItem.title = "More"
        
        self.tabBar.tintColor = UIColor(named: "MainColor")
        
        self.tabBar.backgroundColor = UIColor(named:)
        
        self.viewControllers = [mainVC, moreVC]
    }
}
