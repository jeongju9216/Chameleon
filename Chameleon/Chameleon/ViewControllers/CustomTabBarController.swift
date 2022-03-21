//
//  CustomTabBarController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/21.
//

import UIKit
import SnapKit

class CustomTabBarController: UITabBarController {
 
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewControllers()
        setUpTabBar()
    }
    
    //MARK: - Methods
    private func initViewControllers() {
        let mainVC = UINavigationController(rootViewController: MainViewController())
        mainVC.tabBarItem.image = UIImage(named: "HomeTabIcon")
        mainVC.tabBarItem.title = "Home"
        
        let moreVC = UINavigationController(rootViewController: MoreViewController())
        moreVC.tabBarItem.image = UIImage(named: "MoreTabIcon")
        moreVC.tabBarItem.title = "More"
        
        self.viewControllers = [mainVC, moreVC]
    }
    
    private func setUpTabBar() {
        self.tabBar.clipsToBounds = true
        
        self.tabBar.tintColor = UIColor(named: "MainColor")
        self.tabBar.backgroundColor = UIColor(named:"TabBarColor")
        
        self.tabBar.layer.borderWidth = 3
        self.tabBar.layer.borderColor = UIColor(named: "TabBarBorderColor")?.cgColor
        
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
