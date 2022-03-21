//
//  ViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/15.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        test()
    }

    func test() {
        let test = UILabel()
        view.backgroundColor = .white // 배경색
        view.addSubview(test)
        
        test.text = "text" // test를 위해서 출력할 라벨
        test.textColor = .blue
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainController
    
    func makeUIViewController(context: Context) -> MainController {
        return MainController()
    }
    
    func updateUIViewController(_ uiViewController: MainController, context: Context) {
        
    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ViewControllerRepresentable()
        }
    }
}
