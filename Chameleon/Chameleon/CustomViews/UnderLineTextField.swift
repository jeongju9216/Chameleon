//
//  UnderLineTextField.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit
import SnapKit

class UnderLineTextField: UITextField {
    private let underLineView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        underLineView.backgroundColor = .lightGray
        
        addSubview(underLineView)
        underLineView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
