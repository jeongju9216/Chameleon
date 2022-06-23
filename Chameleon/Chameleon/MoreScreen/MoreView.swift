//
//  MoreView.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

final class MoreView: UIView {
    
    //MARK: - Views
    var tableView: UITableView!
    var titleLabel: UILabel!
    
    private var tabbarBorderView: UIView!
    private var tabbarHeight: CGFloat = 0
    private var tabbarPadding: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, tabbarHeight: CGFloat, tabbarPadding: CGFloat) {
        self.init(frame: frame)
        
        self.tabbarHeight = tabbarHeight
        self.tabbarPadding = tabbarPadding
        print("tabbarHeight: \(tabbarHeight) / tabbarPadding: \(tabbarPadding)")
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.backgroundColor
        
        setupTitleLabel()
        setupTableView()
        setupTabbarBorder()
    }
    
    private func setupTabbarBorder() {
        tabbarBorderView = UIView(frame: .zero)
        tabbarBorderView.translatesAutoresizingMaskIntoConstraints = false

        tabbarBorderView.backgroundColor = UIColor(named: "TabBarBorderColor")
        tabbarBorderView.alpha = 0.5
        tabbarBorderView.layer.cornerRadius = (tabbarHeight - tabbarPadding - 10) * 0.41
        tabbarBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.addSubview(tabbarBorderView)
        tabbarBorderView.widthAnchor.constraint(equalToConstant: self.frame.width + 3).isActive = true
        tabbarBorderView.heightAnchor.constraint(equalToConstant: tabbarHeight - 10).isActive = true
        tabbarBorderView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tabbarBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "설정"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .backgroundColor
        tableView.alwaysBounceVertical = false
        tableView.separatorInset.left = 20
        
        self.addSubview(tableView)
        tableView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
}
