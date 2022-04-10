//
//  User.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import Foundation

final class User {
    static let shared: User = User()
    
    var email: String?
    var name: String?
    
    var childName: String? {
        return email?.replacingOccurrences(of: ".", with: "_")
    }
}
