//
//  DateUtils.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/11.
//

import UIKit

final class DateUtils {
    static func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter() //객체 생성
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.string(from: Date())
    }
}
