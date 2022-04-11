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
    
    func fetchUserData(user: Firebase.User) {
        Database.database().reference(withPath: "users").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            print("fetchUserData snapshot: \(snapshot)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(arrayLiteral: snapshot.value), options: [])
                print("data: \(data)")
                
                let decoder = JSONDecoder()
                let userInfo: [UserInfo] = try decoder.decode([UserInfo].self, from: data)
                print("uesrInfo: \(userInfo[0])")
                
                User.shared.fetchUserInfo(userInfo: userInfo[0])
            } catch let error {
                print("fetchUserData error: \(error.localizedDescription)")
            }
        }
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
