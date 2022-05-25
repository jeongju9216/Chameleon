//
//  ImageFile.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/04.
//

import Foundation
import UIKit

struct MediaFile {
    let url: URL
    var data: Data?
    
    var urlString: String {
        url.absoluteString.lowercased()
    }
    
    var filename: String {
        urlString.components(separatedBy: "/").last ?? "unknown"
    }
    
    var `extension`: String {
        urlString.components(separatedBy: ".").last ?? "unknown"
    }
    
    init(url: URL, data: Data? = nil) {
        self.url = url
        self.data = data
    }
}
