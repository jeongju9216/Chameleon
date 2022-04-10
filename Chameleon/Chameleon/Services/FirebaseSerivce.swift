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
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func signUp(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func addUser(withEmail email: String) {
        guard let childName = User.shared.childName,
              let userName = User.shared.name else { return }

        let usersReference = Database.database().reference(withPath: "users")
                
        let userItem = usersReference.child(childName)
        let values: [String: Any] = ["name": "\(userName)-name", "profile": "\(userName)-profile", "gender": "\(userName)-gender", "age": "\(userName)-age"]
        
        userItem.setValue(values)
    }
    
    func deleteAccount(completion: ((Error?) -> Void)?) {
        let user = Auth.auth().currentUser
        user?.delete(completion: completion)
        
        let usersReference = Database.database().reference(withPath: "users")
        
        guard let key = usersReference.child(<#T##pathString: String##String#>)
    }
}
