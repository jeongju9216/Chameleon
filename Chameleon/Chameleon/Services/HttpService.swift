//
//  HttpService.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

struct Response: Codable {
    let result: String
    let message: String
}

class HttpService {
    static let shared: HttpService = HttpService()
    private init() { }
    
    private let serverIP: String = ""
    
    func serverTest() {
        
    }
    
    func uploadImage(params: [String: Any], image: ImageFile) {
        let body = createUploadImageBody(params: params, boundary: UUID().uuidString, image: image)
        print("\(#fileID) \(#line)-line, \(#function)")
        print("body: \(body)")
        
        requestMultipartForm(body: body)
    }
    
}

extension HttpService {
    private func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET -> \(error!)")
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }
    
    private func requestPost(url: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }

    func requestMultipartForm(body: Data) {
        
    }
    
}

extension HttpService {
    private func createUploadImageBody(params: [String: Any], boundary: String, image: ImageFile) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in params {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(image.filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
        if let imageData = image.data {
            body.append(imageData)
        }
        body.append("\r\n".data(using: .utf8)!)
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        
        return body
    }
}
