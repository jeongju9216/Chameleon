//
//  HttpService.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

struct Response: Codable {
    let result: String
    let message: String?
}


class HttpService {
    static let shared: HttpService = HttpService()
    private init() { }
    
    private let serverIP: String = "http://52.79.248.204:5000"
    private let boundary: String = UUID().uuidString
    
    func serverTest() {
        requestGet(url: serverIP + "/server-test", completionHandler: { (result, response) in
            print("response: \(response)")
        })
    }
    
    func multipartServerTest() {
        requestMultipartForm(url: serverIP + "/test/post", params: ["message": "TEST"], completionHandler: { (result, response) in
            print("response: \(response)")
            
        })
    }
    
    func uploadImage(params: [String: Any], image: ImageFile) {
        print("\(#fileID) \(#line)-line, \(#function)")
        requestMultipartForm(url: serverIP + "/file/upload", params: params, image: image) { (result, response) in
            print("response: \(response)")
            
        }
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

    func requestMultipartForm(url: String, params: [String: Any], image: ImageFile, completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createUploadImageBody(params: params, image: image)
        
        print("request: \(request)")
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                var res = response as? HTTPURLResponse
                print("Error: HTTP request failed: \(res?.statusCode) / \(res?.debugDescription)")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }

    func requestMultipartForm(url: String, params: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createBody(params: params)
        
        print("request: \(request)")
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                var res = response as? HTTPURLResponse
                print("Error: HTTP request failed: \(res?.statusCode) / \(res?.debugDescription)")
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output.result)
        }.resume()
    }

}

extension HttpService {
    
    private func createBody(params: [String: Any]) -> Data {
        let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8)!
        let endBoundary = "--\(boundary)--\r\n".data(using: .utf8)!
        let lineBreak = "\r\n"
        
        var body = Data()
        
        for (key, value) in params {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append(endBoundary)

        return body
    }
    
    private func createUploadImageBody(params: [String: Any], image: ImageFile) -> Data {
        print("image: \(image.type) / \(image.filename) / \(image.data) / boundary: \(boundary)")
        
        let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8)!
        let endBoundary = "--\(boundary)--\r\n".data(using: .utf8)!
        let lineBreak = "\r\n"
        
        var body = Data()
                
        body.append(boundaryPrefix)
        
        if let imageData = image.data {
            body.append("Content-Disposition: form-data; name=\"file\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: image/\(image.type)\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(imageData)
            body.append(lineBreak.data(using: .utf8)!)
        }
        
        body.append(endBoundary)
        
        return body
    }
}
