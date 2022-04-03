//
//  UnderLineTextField.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

class UnderLineTextField: UITextField {
    private var underLineView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        underLineView = UIView()
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        
        underLineView.backgroundColor = .lightGray
        
        addSubview(underLineView)
        underLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underLineView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        underLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        underLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
