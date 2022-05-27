//
//  CustomTabBarController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/21.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
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
        fatalError("init(coder:) has not been implemented")
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
        tabBar.clipsToBounds = true
        
        tabBar.tintColor = UIColor.mainColor
        tabBar.backgroundColor = UIColor(named:"TabBarColor")

        let tabBarHeight = tabBar.frame.height
        tabBar.layer.cornerRadius = tabBarHeight * 0.41
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let borderView = UIView()
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        borderView.backgroundColor = UIColor(named: "TabBarBorderColor")
        borderView.layer.cornerRadius = tabBarHeight * 0.41
        borderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addSubview(borderView)
        borderView.widthAnchor.constraint(equalToConstant: tabBar.frame.width + 3).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        borderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13).isActive = true
        
        view.bringSubviewToFront(tabBar)
    }
    
    class CustomTabBar: UITabBar {
        override func sizeThatFits(_ size: CGSize) -> CGSize {
            var sizeThatFits = super.sizeThatFits(size)
            sizeThatFits.height = sizeThatFits.height + 10
            return sizeThatFits
        }
    }
}

extension CALayer {
    func addBorder(_ edges: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height + 10)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height + 10)
                break
            default: break
            }
            
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
