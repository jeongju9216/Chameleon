//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class MoreViewController: BaseViewController {

    //MARK: - Views
    private var tableView: UITableView!
    private var titleLabel: UILabel!
    private var deleteAccountButton: UIButton!
    
    //MARK: - Properties
    private var menus1: [String] = ["애플리케이션 정보", "도움말"]
//    private var menus2: [String] = ["알림 설정", "화면 설정"]
    
    private var menuIcons1: [String] = ["info.circle", "questionmark.circle"]
//    private var menuIcons2: [String] = ["bell", "sun.min"]
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoreUI()
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Methods
    
    //MARK: - Setup
    private func setupMoreUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "")
        
        setupTitleLabel()
        setupTableView()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "설정"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .backgroundColor
        tableView.alwaysBounceVertical = false
        tableView.separatorInset.left = 20
        
        view.addSubview(tableView)
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch menus1[indexPath.row] {
            case "애플리케이션 정보":
                let infoViewController = InfoViewController()
                self.present(infoViewController, animated: true)
            case "도움말":
                let guideViewController = GuideViewController()
                self.present(guideViewController, animated: true)
            default: break
            }
            break
        case 1:
            break
        default : break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section > 0 else { return "" }
        
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return menus1.count
//        case 1: return menus2.count
        default : break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .backgroundColor
        
        var title = "", iconName = ""
        switch indexPath.section {
        case 0:
            title = menus1[indexPath.row]
            iconName = menuIcons1[indexPath.row]
//        case 1:
//            title = menus2[indexPath.row]
//            iconName = menuIcons2[indexPath.row]
        default : break
        }
        
        cell.textLabel?.text = title
        
        cell.imageView?.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .label
        
        return cell
    }
}
