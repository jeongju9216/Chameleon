//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class MoreViewController: BaseViewController {

    //MARK: - Views
    var moreView: MoreView!
    
    //MARK: - Properties
    var menu: [(name: String, icon: String)] = MoreData().menu
    
    //MARK: - DataSource
    let moreDataSource: MoreDataSource = MoreDataSource()
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: "")
        
        moreDataSource.menu = self.menu

        moreView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        moreView.tableView.delegate = self
        moreView.tableView.dataSource = moreDataSource
    }
    
    override func loadView() {
        super.loadView()
        
        moreView = MoreView(frame: self.view.frame)
        self.view = moreView
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menu[indexPath.row].name {
        case "애플리케이션 정보":
            let infoViewController = InfoViewController()
            self.present(infoViewController, animated: true)
        case "도움말":
            let guideViewController = GuideViewController()
            self.present(guideViewController, animated: true)
        case "개인정보처리방침":
            if let url = URL(string: "https://raw.githubusercontent.com/fitness-houston/PersonalInformation/main/README.md")  {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
