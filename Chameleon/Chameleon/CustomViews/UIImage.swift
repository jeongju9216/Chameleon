//
//  UIImage.swift
//  Chameleon
//
//  Created by 유정주 on 2022/04/12.
//

import UIKit

extension UIImage {
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
    
    convenience init?(base64: String, withPrefix: Bool) {
        var finalData: Data?

        if withPrefix {
            guard let url = URL(string: base64) else { return nil }
            finalData = try? Data(contentsOf: url)
        } else {
            finalData = Data(base64Encoded: base64)
        }

        guard let data = finalData else { return nil }
        self.init(data: data)
    }
    
//    withPrefix는 base64 형식에는 꼭 붙는 string을 말합니다.
//    아래와 같은 base64 스트링이 있을때, "image/png;base64" 이 부분입니다.
//    data:image/png;base64,iV~~~
//
//    Data(baseEncoded:) 를 활용하여 encode 하는 경우, prefix가 붙으면 안 되기 때문에,
//    이때는 파라미터로 prefix가 제거된 string을 넣어줘야 합니다.
}
