// MIT License
//
// Copyright (c) 2025 Josep Cerdá Penadés
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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

