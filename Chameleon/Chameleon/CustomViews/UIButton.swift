//
//  UIButton.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/23.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
            
            let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.setBackgroundImage(backgroundImage, for: state)
        }
    }
}
