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
    
    var currentVersion = "0.0.1" //현재버전
    var lastetVersion = "0.0.1" //최신버전
    var forcedUpdateVersion = "0.0.1" //강제 업데이트 버전
    
    var isNeedUpdate: Bool { //업데이트가 필요한가?
        get {
            compareVersion(curruent: currentVersion, compare: lastetVersion)
        }
    }
    
    var isNeedForcedUpdate: Bool { //강제 업데이트가 필요한가?
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
