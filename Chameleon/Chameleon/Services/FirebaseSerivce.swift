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
    var user: Firebase.User?
    
    func login(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func fetchUserData(completion: @escaping (DataSnapshot) -> Void) {
        guard let user = self.user else { return }

        Database.database().reference(withPath: "users").child(user.uid).observeSingleEvent(of: .value, with: completion)
    }
    
    func decodeUserData(_ snapshot: Firebase.DataSnapshot) {
        do {
            let data = try JSONSerialization.data(withJSONObject: Array(arrayLiteral: snapshot.value), options: [])
            print("data: \(data)")
            
            let decoder = JSONDecoder()
            let userInfo: [UserInfo] = try decoder.decode([UserInfo].self, from: data)
//            print("uesrInfo: \(userInfo[0])")
            
            User.shared.fetch(userInfo: userInfo[0])
        } catch let error {
            print("fetchUserData error: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    func signUp(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func addUser() {
        guard let user = self.user else {
            return
        }
        
        let usersReference = Database.database().reference(withPath: "users")
                
        let userItem = usersReference.child(user.uid)
        let values: [String: Any] = ["email":"\(User.shared.email)", "name": "\(User.shared.name)", "profile": "\(User.shared.profile)", "gender": "\(User.shared.gender)", "age": "\(User.shared.age)"]
        
        print("addUser email: \(User.shared.email)")
        print("addUser name: \(User.shared.name)")
        
        userItem.setValue(values)
    }
    
    func deleteAccount(completion: ((Error?) -> Void)?) {
        guard let user = Auth.auth().currentUser else { return }
        user.delete(completion: completion)
        Database.database().reference(withPath: "users").child(user.uid).removeValue()
    }
}
