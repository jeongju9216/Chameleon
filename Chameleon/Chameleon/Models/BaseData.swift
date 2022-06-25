//
//  BaseData.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/11.
//

import Foundation

final class BaseData {
    static var shared = BaseData()
    
    let appleID = "1625706929"
    let bundleID = "com.jeong9216.Chameleon"
    
    var currentVersion = "0.0.1"
    var lastetVersion = "0.0.1"
    var forcedUpdateVersion = "0.0.1"
    
    var isNeedUpdate: Bool {
        get {
            compareVersion(curruent: currentVersion, compare: lastetVersion)
        }
    }
    
    var isNeedForcedUpdate: Bool {
        get {
            compareVersion(curruent: currentVersion, compare: forcedUpdateVersion)
        }
    }
    
    private func compareVersion(curruent: String, compare: String) -> Bool {
        let compareResult = curruent.compare(compare, options: .numeric)
        switch compareResult {
        case .orderedAscending:
            return true
        case .orderedDescending, .orderedSame:
            return false
        }
    }
}
