//
//  ChooseFaceViewController.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit
import SnapKit

class ChooseFaceViewController: BaseViewController {
    
    //MARK: - Views
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChooseFaceUI()
    }
    
    //MARK: - Methods
    private func setupChooseFaceUI() {
        view.backgroundColor = UIColor().backgroundColor()
        setupNavigationBar(title: "바꾸지 않을 얼굴 선택")
    }
    
    
}

