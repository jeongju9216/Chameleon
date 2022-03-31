//
//  UIColor.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/24.
//

import UIKit

extension UIColor {
    
    class var mainColor: UIColor {
        return UIColor(named: "MainColor") ?? .black
    }
    
    class var buttonColor: UIColor {
        return UIColor(named: "ButtonColor") ?? .black
    }
    
    class var buttonClickColor: UIColor {
        return UIColor(named: "ButtonClickColor") ?? .black
    }

    class var buttonBorderColor: UIColor {
        return UIColor(named: "ButtonBorderColor") ?? .black
    }
    
    class var backgroundColor: UIColor {
        return UIColor(named: "BackgroundColor") ?? .black
    }
    
    class var edgeColor: UIColor {
        return UIColor(named: "EdgeColor") ?? .lightGray
    }
    
    class var shadowColor: UIColor {
        return UIColor(named: "ShadowColor") ?? .darkGray
    }
}
