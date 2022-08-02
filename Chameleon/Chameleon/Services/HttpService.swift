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
    
    typealias Output = (result: Bool, response: Any)
    
    var retryCount = 0
    let maxRetryCount = 3, maxFaceRetryCount = 30
    let errorOutput: Output = (false, "ERROR")
    
    private let okString = "ok"
    private let serverIP: String = "https://chameleon161718.xyz"
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
    
    //MARK: - GET
    func getFaces(waitingTime: Int) async -> Output {
        var output: Output = errorOutput
        for _ in 0..<self.maxFaceRetryCount {
            try? await Task.sleep(nanoseconds: UInt64(waitingTime * 1_000_000_000))
            output = await requestGet(url: self.serverIP + "/faces")
            if output.result {
                return output
            }
        }
        
        return output
    }
    
    func getResultFile() async -> Output {
        let output: Output = await requestGet(url: self.serverIP + "/file/download")
        return output
    }
    
    //MARK: - Post
    func sendCheckedFaces(params: [String: Any]) async -> Output {
        var output: Output = errorOutput
        for _ in 0..<maxRetryCount {
            output =  await requestPost(url: serverIP + "/faces", param: params)
            if output.result {
                return output
            }
        }
        return output
    }
    
    func deleteFiles() async -> Output {
        var output: Output = errorOutput
        for _ in 0..<maxRetryCount {
            output =  await requestPost(url: serverIP + "/file/delete", param: ["message": "delete"])
            if output.result {
                return output
            }
        }
        return output
    }
    
    func cancelFiles() async -> Output {
        var output: Output = errorOutput
        for _ in 0..<maxRetryCount {
            output =  await requestPost(url: serverIP + "/file/cancel", param: ["message": "delete"])
            if output.result {
                return output
            }
        }
        return output
    }
    
    //MARK: - Multipart
    func uploadMedia(params: [String: Any], media: MediaFile) async -> Output {
        let ouput = await requestMultipartForm(url: serverIP + "/file/upload", params: params, media: media)
        return ouput
    }
}

extension HttpService {
    private func requestGet(url: String) async -> Output {
        print("[GET] url: \(url)")
        guard let url = URL(string: url) else {
            return (false, "Error: cannot create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200  else {
                return (false, "Error: statusCode is not 200")
            }
            
            if let output = try? JSONDecoder().decode(Response.self, from: data) {
                return (output.result == self.okString, output)
            } else {
                let output = try JSONDecoder().decode(FaceResponse.self, from: data)
                return (output.result == self.okString, output)
            }
        } catch {
            return (false, "[requestGet] Error \(error.localizedDescription)")
        }
    }
    
    private func requestPost(url: String, param: [String: Any]) async -> Output {
        print("[POST] url: \(url) / param: \(param)")
        let sendData = try? JSONSerialization.data(withJSONObject: param, options: [])
        guard let sendData = sendData else {
            return (false, "Error: cannot create sendData")
        }
        
        guard let url = URL(string: url) else {
            return (false, "Error: cannot create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard (response as? HTTPURLResponse)?.statusCode == 200  else {
                return (false, "Error: statusCode is not 200")
            }
            
            let output = try JSONDecoder().decode(Response.self, from: data)
            return (output.result == self.okString, output)
        } catch {
            return (false, "[requestPost] Error \(error.localizedDescription)")
        }
    }

    func requestMultipartForm(url: String, params: [String: Any], media: MediaFile) async -> Output {
        print("[requestMultipartForm] url: \(url)")
        guard let url = URL(string: url) else {
            return (false, "Error: cannot create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authorization, forHTTPHeaderField: authorizationHeaderKey)
        request.addValue("multipart/form-data; boundary=\(authorization)", forHTTPHeaderField: "Content-Type")
        
        let reqeustData = createUploadBody(params: params, media: media)
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: reqeustData)
            guard (response as? HTTPURLResponse)?.statusCode == 200  else {
                return (false, "Error: statusCode is not 200")
            }
            
            let output = try JSONDecoder().decode(Response.self, from: data)
            return (output.result == self.okString, output)
        } catch {
            return (false, "[requestMultipartForm] Error \(error.localizedDescription)")
        }
    }
}

extension HttpService {
    private func createUploadBody(params: [String: Any], media: MediaFile) -> Data {
        let lineBreak = "\r\n"
        let boundaryPrefix = "--\(authorization)\(lineBreak)".data(using: .utf8)!
        let endBoundary = "--\(authorization)--\(lineBreak)".data(using: .utf8)!
        
        var body = Data()
                
        body.append(boundaryPrefix)
        
        let contentsType = (UploadData.shared.uploadType == .Photo) ? "image/\(media.extension)" : "video/\(media.extension)"
        print("media: \(media.filename) / \(media.extension) / \(contentsType)")
        if let imageData = media.data {
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(media.filename)\"\(lineBreak)".data(using: .utf8)!)
            body.append("Content-Type: \(contentsType)\(lineBreak + lineBreak)".data(using: .utf8)!)
            body.append(imageData)
            body.append(lineBreak.data(using: .utf8)!)
        }
        
        body.append(endBoundary)
        
        return body
    }
}
