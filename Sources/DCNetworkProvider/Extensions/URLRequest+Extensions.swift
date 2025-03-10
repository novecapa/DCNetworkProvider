//
//  URLRequest+Extensions.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

extension URLRequest {
    mutating func addRequestParams(_ params: DCRequestParams?) {
        guard let params else { return }
        switch params {
        case .multipart(let postData):
            self.addMultipartFormData(postData)
        case .urlEncoded(let postData):
            self.addUrlEncoded(postData)
        case .bodyRaw(let postData):
            self.addBodyRaw(postData)
        case .headers(let postData):
            self.addHeaders(postData)
        default:
            break
        }
    }

    private mutating func addMultipartFormData(_ postData: [String: Any?]) {
        let boundary = "Boundary-\(UUID().uuidString)"
        setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        for (key, value) in postData {
            if let data = "--\(boundary)\r\n".toData {
                body.append(data)
            }
            if let data = "Content-Disposition: form-data; name='\(key)'\r\n\r\n".toData {
                body.append(data)
            }
            if let value,
               let data = "\(value)\r\n".toData {
                body.append(data)
            }
        }
        if let data = "--\(boundary)--\r\n".toData {
            body.append(data)
            httpBody = body
        }
    }

    private mutating func addUrlEncoded(_ postData: [String: Any?]?) {
        guard let postData else { return }
        setValue("application/json", forHTTPHeaderField: "accept")
        setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var params = ""
        for (key, value) in postData {
            if let value {
                params.append("\(key)=\(value)&")
            }
        }
        if let postData = params.data(using: .utf8) {
            httpBody = postData
        }
    }

    private mutating func addBodyRaw(_ postData: Data?) {
        guard let postData else { return }
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpBody = postData
    }

    private mutating func addHeaders(_ headers: [String: Any]?) {
        headers?.forEach { (key: String, value: Any) in
            if let stringValue = value as? String, !stringValue.isEmpty {
                setValue(stringValue, forHTTPHeaderField: key)
            }
        }
    }
}

private extension String {
    var toData: Data? {
        self.data(using: .utf8)
    }
}

