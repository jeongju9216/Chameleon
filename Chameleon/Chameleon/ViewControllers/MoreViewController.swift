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
        view.backgroundColor = UIColor().backgroundColor() // 배경색
        view.addSubview(test)
    }
}

