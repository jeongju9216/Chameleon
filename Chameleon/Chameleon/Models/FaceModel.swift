//
//  FaceModel.swift
//  Chameleon
//
//  Created by 유정주 on 2022/05/11.
//

import Foundation

struct FaceModel {
    let images: [FaceImage]
}

struct FaceImage {
    let url: String?
    let name: String
    let gender: String
    let percent: Int
}
