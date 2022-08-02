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
    
    func checkServer() async -> (Bool, String) {
        do {
            let snapshot = try await firebaseRef.child("version/").getData()
            let snapData = snapshot.value as? [String: Any]
            
            let result = snapData?["result"] as? String ?? "failed"
            let message = snapData?["message"] as? String ?? ""
            print("[checkServer] result: \(result) / message: \(message)")
            
            return (result.lowercased() == "ok", message)
        } catch {
            print("[checkServer] Error: \(error.localizedDescription)")
            return (false, "failed")
        }
    }

    func fetchVersion() async -> (String, String) {
        do {
            let snapshot = try await firebaseRef.child("version/data").getData()
            let snapData = snapshot.value as? [String: String]

            let versions: (String, String) = (snapData?["lasted"] ?? "0.0.0", snapData?["forced"] ?? "0.0.0")
            print("[fetchVersion] versions: \(versions)")

            return versions
        } catch {
            print("[fetchVersion] Error: \(error.localizedDescription)")
            return ("0.0.0", "0.0.0")
        }
    }
}
