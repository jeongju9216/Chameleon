//
//  FirebaseSerivce.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import Foundation
import FirebaseAuth
import Firebase

final class FirebaseService {
    static let shared = FirebaseService()
    
    func login(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
        User.shared.email = email
        User.shared.name = String((email.split(separator: "@"))[0])
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func signUp(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func addUser(_ user: Firebase.User) {
        guard let userEmail = User.shared.email,
              let userName = User.shared.name else { return }

        let usersReference = Database.database().reference(withPath: "users")
                
        let userItem = usersReference.child(user.uid)
        let values: [String: Any] = ["email":"\(userEmail)", "name": "\(userName)-name", "profile": "\(userName)-profile", "gender": "\(userName)-gender", "age": "\(userName)-age"]
        
        userItem.setValue(values)
    }
    
    func deleteAccount(completion: ((Error?) -> Void)?) {
        guard let user = Auth.auth().currentUser else { return }
        user.delete(completion: completion)
        Database.database().reference(withPath: "users").child(user.uid).removeValue()
    }
}
