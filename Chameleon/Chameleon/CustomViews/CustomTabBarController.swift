//
//  CustomTabBarController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/21.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    //MARK: - Views
    var borderView: UIView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewControllers()
        setupTabBar()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBar.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Methods
    private func initViewControllers() {
        let mainVC = UINavigationController(rootViewController: HomeViewController())
        mainVC.tabBarItem.image = UIImage(named: "HomeTabIcon")
        mainVC.tabBarItem.title = "Home"
        
        let moreVC = UINavigationController(rootViewController: MoreViewController())
        moreVC.tabBarItem.image = UIImage(named: "MoreTabIcon")
        moreVC.tabBarItem.title = "More"
        
        self.viewControllers = [mainVC, moreVC]
    }
    
    private func setupTabBar() {        
        tabBar.tintColor = UIColor.mainColor
        tabBar.backgroundColor = UIColor(named:"TabBarColor")

        tabBar.layer.cornerRadius = (tabBar.frame.height + 10) * 0.30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    class CustomTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = sizeThatFits.height + 10
            return sizeThatFits
        }
    }
}
