//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test()
    }

    func test() {
        let test = UILabel()
        view.backgroundColor = .white // 배경색
        view.addSubview(test)
        
        test.text = "MoreViewController" // test를 위해서 출력할 라벨
        test.textColor = .blue
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

