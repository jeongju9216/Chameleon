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
    private var withdrawalButton: UIButton!
    
    //MARK: - Properties
    private var menus1: [String] = ["앱 정보", "도움말"]
    private var menus2: [String] = ["알림 설정", "화면 설정"]
    private var menus3: [String] = ["문의하기", "로그아웃"]
    
    private var menuIcons1: [String] = ["info.circle", "questionmark.circle"]
    private var menuIcons2: [String] = ["bell", "sun.min"]
    private var menuIcons3: [String] = ["person", "arrowshape.turn.up.left"]
    
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMoreUI()
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Methods
    private func showLogoutActionSheet() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "확인", style: .default) { (action) in
            print("Remove Auth!!")

            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.synchronize()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: - Setup
    private func setupMoreUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar(title: "")
        
        setupTitleLabel()
        setupWithdrawalButton()
        setupTableView()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "설정"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func setupWithdrawalButton() {
        withdrawalButton = UIButton(type: .system)
        withdrawalButton.setTitle("회원 탈퇴", for: .normal)
        withdrawalButton.setTitleColor(.lightGray, for: .normal)
        withdrawalButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        view.addSubview(withdrawalButton)
        withdrawalButton.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.alwaysBounceVertical = false
        tableView.separatorInset.left = 20
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(withdrawalButton.snp.top).offset(-10)
        }
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            switch menus3[indexPath.row] {
            case "로그아웃":
                showLogoutActionSheet()
            default: break
            }
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
        if section == 0 {
            return ""
        }
        
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return menus1.count
        case 1: return menus2.count
        case 2: return menus3.count
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
        case 1:
            title = menus2[indexPath.row]
            iconName = menuIcons2[indexPath.row]
        case 2:
            title = menus3[indexPath.row]
            iconName = menuIcons3[indexPath.row]
        default : break
        }
        cell.textLabel?.text = title
        
        cell.imageView?.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .label
        
        return cell
    }
}
