//
//  MoreDataSource.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/17.
//

import UIKit

class MoreDataSource: NSObject, UITableViewDataSource {
    var menu: [(name: String, icon: String)] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = menu[indexPath.row].name
        let iconName = menu[indexPath.row].icon
        
        let cell: UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as UITableViewCell
        
        cell.backgroundColor = .backgroundColor
        cell.textLabel?.text = title
        cell.imageView?.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .label
        
        return cell
    }
}
