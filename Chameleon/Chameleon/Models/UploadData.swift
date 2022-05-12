//
//  UploadData.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

final class UploadData {
    static let shared: UploadData = UploadData()
    
    var uploadType: UploadType = .Video
    var uploadTypeString: String {
        return (uploadType == .Photo) ? "사진" : "영상"
    }
    var convertType: Int = ConvertType.face.rawValue
}

enum UploadType: String {
    case Photo
    case Video
}

enum ConvertType: Int {
    case face
    case mosaic
    case all
}
