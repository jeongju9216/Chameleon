//
//  FirebaseSerivce.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import Foundation
import FirebaseAuth

final class FirebaseService {
    static let shared = FirebaseService()
    
    func login(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func signUp(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func deleteAccount(completion: ((Error?) -> Void)?) {
        let user = Auth.auth().currentUser
        user?.delete(completion: completion)
    }
}
