//
//  User.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import Foundation

final class User {
    static let shared: User = User()
    let defaultValue = "Unknown"
 
    var email: String = "Unknown"
    var name: String = "Unknown"
    var profile: String = "Unknown"
    var age: String = "Unknown"
    var gender: String = "Unknown"
    
    init() {
    }
    
    func fetch(userInfo: UserInfo) {
        self.email = userInfo.email
        self.name = userInfo.name
        self.profile = userInfo.profile
        self.age = userInfo.age
        self.gender = userInfo.gender
    }
    
    func setProfile(name: String, age: String, gender: String, profile: String) {
        self.name = name
        self.profile = profile
        self.age = age
        self.gender = gender
    }
    
    func removeAll() {
        self.email = self.defaultValue
        self.name = self.defaultValue
        self.profile = self.defaultValue
        self.age = self.defaultValue
        self.gender = self.defaultValue
    }
}

struct UserInfo: Codable {
    let email: String
    let profile: String
    let age: String
    let gender: String
    let name: String
}
