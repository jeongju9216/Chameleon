//
//  UploadInfo.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

final class UploadInfo {
    static let shared: UploadInfo = UploadInfo()
    
    var uploadType: UploadType = .Video
    
    var uploadTypeString: String {
        return (uploadType == .Photo) ? "사진" : "영상"
    }
}

enum UploadType: String {
    case Photo
    case Video
}
