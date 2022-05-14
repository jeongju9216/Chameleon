//
//  HttpService.swift
//  Chameleon
//
//  Created by 유정주 on 2022/03/31.
//

import UIKit

let testJson: String = """
{
    \"result\" : \"ok\",
    \"message\" : \"추출 얼굴 이미지\",
    \"data\" :
    [
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test1\",
            \"gender\" : \"m\",
            \"percent\" : 90
        },
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test2\",
            \"gender\" : \"w\",
            \"percent\" : 6
        },
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test3\",
            \"gender\" : \"m\",
            \"percent\" : 4
        },
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test1\",
            \"gender\" : \"m\",
            \"percent\" : 90
        },
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test2\",
            \"gender\" : \"w\",
            \"percent\" : 6
        },
        {
            \"url\" : \"https://picsum.photos/200\",
            \"name\": \"test3\",
            \"gender\" : \"m\",
            \"percent\" : 4
        }
    ]
}
"""

struct Response: Codable {
    let result: String
    let message: String?
    let data: String?
}

struct FaceResponse: Codable {
    let result: String
    let message: String
    let data: [FaceImage]?
}

class HttpService {
    static let shared: HttpService = HttpService()
    private init() { }
    
    private let serverIP: String = "http://118.91.7.160"
    private let authorizationHeaderKey = "authorization"
    private var authorization: String {
        if let savekey: String = UserDefaults.standard.string(forKey: "authorization") {
            return savekey
        } else {
            let savekey = makeAuthorization()
            UserDefaults.standard.set(savekey, forKey: "authorization")
            UserDefaults.standard.synchronize()
            
            return savekey
        }
    }
    
    func makeAuthorization() -> String {
        return UUID().uuidString + "-" + DateUtils.getCurrentDateTime()
    }
    
    var retryCount = 0
    
    //MARK: - GET
    func loadVersion(completionHandler: @escaping (Bool, Any) -> Void) {
        requestGet(url: serverIP + "/version", completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.loadVersion(completionHandler: completionHandler)
            }
        })
    }
    
    func checkConnectedServer(completionHandler: @escaping (Bool, Any) -> Void) {
        requestGet(url: serverIP + "/server-test", completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.checkConnectedServer(completionHandler: completionHandler)
            }
        })
    }
    
    func getFaces(completionHandler: @escaping (Bool, Any) -> Void) {
        requestGet(url: serverIP + "/faces", completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.getFaces(completionHandler: completionHandler)
            }
        })
    }
    
    func downloadResultFile(completionHandler: @escaping (Bool, Any) -> Void) {
        requestGet(url: serverIP + "/file/download", completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.downloadResultFile(completionHandler: completionHandler)
            }
        })
    }
    
    //MARK: - Post
    func sendUnconvertedFaces(params: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        requestPost(url: serverIP + "/faces", param: params, completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.sendUnconvertedFaces(params: params, completionHandler: completionHandler)
            }
        })
    }
    
    func deleteFiles(completionHandler: @escaping (Bool, Any) -> Void) {
        requestPost(url: serverIP + "/file/delete", param: ["message": "delete"], completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.deleteFiles(completionHandler: completionHandler)
            }
        })
    }
    
    func cancelFiles(completionHandler: @escaping (Bool, Any) -> Void) {
        requestPost(url: serverIP + "/file/cancel", param: ["message": "delete"], completionHandler: { (result, response) in
            if result || self.retryCount == 3 {
                self.retryCount = 0
                completionHandler(result, response)
            } else {
                self.retryCount += 1
                self.cancelFiles(completionHandler: completionHandler)
            }
        })
    }
    
    //MARK: - Multipart
    func uploadMedia(params: [String: Any], media: MediaFile, completionHandler: @escaping (Bool, Any) -> Void) {
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
        request.setValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        
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

            if let output = try? JSONDecoder().decode(Response.self, from: data) {
                completionHandler(output.result == "ok", output)
            } else {
                print("Error: JSON Data Parsing failed")
                
                guard let output = try? JSONDecoder().decode(FaceResponse.self, from: data) else {
                    print("Error: JSON Data Parsing failed")
                    
                    completionHandler(false, "Error: JSON Data Parsing failed")
                    return
                }
                
                completionHandler(output.result == "ok", output)
            }
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
        request.setValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: error calling Post -> \(error!)")
                
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

    func requestMultipartForm(url: String, params: [String: Any], media: MediaFile, completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm 1] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            completionHandler(false, "Error: cannot create URL")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        request.addValue("multipart/form-data; boundary=\(authorization)", forHTTPHeaderField: "Content-Type")
        
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

    func requestMultipartForm(url: String, params: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
        print("[requestMultipartForm 2] url: \(url)")
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            completionHandler(false, "Error: JSON Data Parsing failed")
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        request.addValue("multipart/form-data; boundary=\(authorization)", forHTTPHeaderField: "Content-Type")
        
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

}

extension HttpService {
    private func createBody(params: [String: Any]) -> Data {
        let boundaryPrefix = "--\(authorization)\r\n".data(using: .utf8)!
        let endBoundary = "--\(authorization)--\r\n".data(using: .utf8)!
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
        let lineBreak = "\r\n"
        let boundaryPrefix = "--\(authorization)\(lineBreak)".data(using: .utf8)!
        let endBoundary = "--\(authorization)--\(lineBreak)".data(using: .utf8)!
        
        var body = Data()
                
        body.append(boundaryPrefix)
        
        if let imageData = media.data {
            let filename: String = (authorization + ".\((media.type).components(separatedBy: "/").last!)")
            print("filename: \(filename)")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: \(media.type)\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(imageData)
            body.append(lineBreak.data(using: .utf8)!)
        }
        
        body.append(endBoundary)
        
        return body
    }
}
