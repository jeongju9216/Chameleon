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
    
    private let serverIP: String = "api"
    private let boundary: String = "Boundary-\(UUID().uuidString)"
    
    var retryCount = 0
    
    func checkConnectedServer(completionHandler: @escaping (Bool, Any) -> Void) {
        print("Here?")
        requestGet(url: serverIP + "/server-test", completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                print("Here")
                self.retryCount += 1
                self.checkConnectedServer(completionHandler: completionHandler)
            }
        })
    }
    
    func multipartServerTest() {
        requestMultipartForm(url: serverIP + "/test", params: ["message": "TEST"], completionHandler: { (result, response) in
            print("\(self.serverIP + "/test") response: \(response)")
        })
    }
    
    func uploadMedia(params: [String: Any], media: MediaFile, completionHandler: @escaping (Bool, Any) -> Void) {
        print("\(#fileID) \(#line)-line, \(#function)")
        requestMultipartForm(url: serverIP + "/file/upload", params: params, media: media) { (result, response) in
            completionHandler(result, response)
        }
    }
    
}

extension HttpService {
    private func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            completionHandler(false, "Error: cannot create URL")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET -> \(error!)")
                completionHandler(false, "Error: error calling GET -> \(error!)")
                
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                completionHandler(false, "Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completionHandler(false, "Error: HTTP request failed")
                
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                completionHandler(false, "Error: JSON Data Parsing failed")
                
                return
            }
            
            completionHandler(output.result == "ok", output)
        }.resume()
    }
    
    private func requestPost(url: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
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

    func requestMultipartForm(url: String, params: [String: Any], media: MediaFile, completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            completionHandler(false, "Error: cannot create URL")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createUploadBody(params: params, media: media)
        
        print("request: \(request)")
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                completionHandler(false, "Error: error calling Post")
                
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                completionHandler(false, "Error: Did not receive data")

                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                let res = response as? HTTPURLResponse
                let code = res?.statusCode
                print("Error: HTTP request failed: \(code)")
                completionHandler(false, "Error: HTTP request failed: \(code)")

                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                completionHandler(false, "Error: JSON Data Parsing failed")

                return
            }
            
            completionHandler(output.result == "ok", output)
        }.resume()
    }

    func requestMultipartForm(url: String, params: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            completionHandler(false, "Error: JSON Data Parsing failed")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 3
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createBody(params: params)
        
        print("request: \(request)")
        URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                completionHandler(false, "Error: error calling Post -> \(error!)")
                
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                completionHandler(false, "Error: Did not receive data")
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                let res = response as? HTTPURLResponse
                let code = res?.statusCode
                print("Error: HTTP request failed: \(code)")
                completionHandler(false, "Error: HTTP request failed: \(code)")
                
                return
            }

            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                completionHandler(false, "Error: JSON Data Parsing failed")
                
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
    
    private func createUploadBody(params: [String: Any], media: MediaFile) -> Data {
        print("media: \(media.type) / \(media.filename) / \(media.data) / boundary: \(boundary)")
        
        let lineBreak = "\r\n"
        let boundaryPrefix = "--\(boundary)\(lineBreak)".data(using: .utf8)!
        let endBoundary = "--\(boundary)--\(lineBreak)".data(using: .utf8)!
        
        var body = Data()
                
        body.append(boundaryPrefix)
        
        if let imageData = media.data {
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(media.filename)\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: \(media.type)\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(imageData)
            body.append(lineBreak.data(using: .utf8)!)
        }
        
        body.append(endBoundary)
        
        return body
    }
}
