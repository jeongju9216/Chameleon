//
//  UIColor.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/24.
//

import UIKit

extension UIColor {
    func mainColor() -> UIColor {
        return UIColor(named: "MainColor") ?? .black
    }
    
    func buttonColor() -> UIColor {
        return UIColor(named: "ButtonColor") ?? .black
    }
    
    func buttonClickColor() -> UIColor {
        return UIColor(named: "ButtonClickColor") ?? .black
    }

    func buttonBorderColor() -> UIColor {
        return UIColor(named: "ButtonBorderColor") ?? .black
    }
    
    func backgroundColor() -> UIColor {
        return UIColor(named: "BackgroundColor") ?? .black
    }
    
    func edgeColor() -> UIColor {
        return UIColor(named: "EdgeColor") ?? .lightGray
    }
}
