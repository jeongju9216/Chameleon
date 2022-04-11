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
    var profile: String?
    var age: String?
    var gender: String?
    
    init() {
    }
    
    func fetchUserInfo(userInfo: UserInfo) {
        self.email = userInfo.email
        self.name = userInfo.name
        self.profile = userInfo.profile
        self.age = userInfo.age
        self.gender = userInfo.gender
    }
}

struct UserInfo: Codable {
    let email: String
    let profile: String
    let age: String
    let gender: String
    let name: String
}
