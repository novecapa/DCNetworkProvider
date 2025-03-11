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
//  Log.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

class Log {

    static func thisRequest(_ response: HTTPURLResponse,
                            data: Data,
                            request: URLRequest?, printcURL: Bool = true) {
        let code = response.statusCode
        let url  = response.url?.absoluteString ?? ""
        let icon  = [200, 201, 204].contains(code) ? "✅" : "❌"
        print("------------------------------------------")
        print("\(icon) 🔽 [\(code)] \(url)")
        print("\(data.prettyPrintedJSONString ?? "")")
        if printcURL {
            print("\(request?.curl(pretty: true) ?? "")")
        }
        print("\(icon) 🔼 [\(code)] \(url)")
        print("------------------------------------------")
    }
}

private extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object,
                                                     options: [.withoutEscapingSlashes]),
              let prettyPrintedString = String(data: data,
                                               encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
}

private extension URLRequest {
    func curl(pretty: Bool = false) -> String {
        var data: String = ""
        let complement = pretty ? "\\\n" : ""
        let method = "-X \(self.httpMethod ?? "GET") \(complement)"
        var urlStringPath = ""
        if let urlString = self.url?.absoluteString {
            urlStringPath = urlString
        }
        let url = "\"" + urlStringPath + "\""
        var header = ""
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key, value) in httpHeaders {
                header += "-H \"\(key): \(value)\" \(complement)"
            }
        }
        if let bodyData = self.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            data = "-d \"\(bodyString)\" \(complement)"
        }
        let command = "curl -i " + complement + method + header + data + url
        return command
    }
}
