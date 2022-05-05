//
//  ImageFile.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/04.
//

import Foundation
import UIKit

struct ImageFile {
    let filename: String
    let data: Data?
    let type: String
    
    init(filename: String, data: Data, type: String) {
        self.filename = filename
        self.data = data
        self.type = type
    }
}
