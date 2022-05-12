//
//  UploadData.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/02.
//

import UIKit

final class UploadData {
    static let shared: UploadData = UploadData()
    
    var uploadType: UploadType = .Photo
    var uploadTypeString: String {
        return (uploadType == .Photo) ? "사진" : "영상"
    }
    var convertType: Int = ConvertType.face.rawValue
    var convertTypeString: String {
        var message = ""
        switch convertType {
        case ConvertType.face.rawValue:
            message = "얼굴을 가짜 얼굴로 변환합니다."
        case ConvertType.mosaic.rawValue:
            message = "얼굴을 모자이크 합니다."
        case ConvertType.all.rawValue:
            message = "얼굴을 가짜 얼굴로 변환하고 모자이크 합니다."
        default: break
        }
        
        return message
    }
    
    func clearData() {
        uploadType = .Photo
        convertType = ConvertType.face.rawValue
    }
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
