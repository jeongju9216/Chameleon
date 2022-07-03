//
//  FirebaseService.swift
//  Chameleon
//
//  Created by 유정주 on 2022/07/03.
//

import UIKit
import Firebase

class FirebaseService {
    static let shared: FirebaseService = FirebaseService()
    init() { }

    //MARK: - Properties
    private var firebaseRef: DatabaseReference!
    
    //MARK: - Methods
    func configureFirebase() {
        FirebaseApp.configure()
    }
    
    func initDatabase() {
        firebaseRef = Database.database().reference()
    }
    
    func checkServer(completionHandler: @escaping ((Bool, String) -> Void)) {
        firebaseRef.child("version/").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapData = snapshot.value as? [String: Any] else {
                print("snapshot.value: \(String(describing: snapshot.value))")
                return
            }
            print("[checkServer] snapData: \(snapData)")
            
            let result = snapData["result"] as? String ?? "failed"
            let message = snapData["message"] as? String ?? ""
            print("[checkServer] result: \(result) / message: \(message)")
            
            completionHandler(result == "ok", message)
        });
    }

    func fetchVersion(completionHandler: @escaping ((Bool, [String]) -> Void)) {
        firebaseRef.child("version/data").getData(completion:  { error, snapshot in
            guard let snapData = snapshot.value as? [String: String] else {
                print("snapshot.value: \(String(describing: snapshot.value))")
                return
            }
            
            let versions: [String] = [snapData["lasted"] ?? "0.0.1", snapData["forced"] ?? "0.0.1"]
            print("[fetchVersion] snapData: \(snapData)")
            
            completionHandler(true, versions)
        });
    }
}
