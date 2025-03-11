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
//  DCNetworkProvider.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

/// A network client responsible for making HTTP requests and decoding responses.
///
/// This class conforms to `DCNetworkProvider` and provides an asynchronous method
/// to perform network calls using `URLSession`.
public final class DCNetworkProvider: DCNetworkProviderProtocol {
    
    /// The URL session used for making network requests.
    let urlSession: URLSessionProtocol
    
    /// Initializes the network client with a custom URL session.
    /// - Parameter urlSession: A protocol-conforming URL session instance.
    public init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    /// Performs an asynchronous network request and decodes the response into the specified type.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL of the request.
    ///   - method: The HTTP method to use (default is `.get`).
    ///   - params: Optional request parameters (query or body).
    ///   - type: The type of the expected response, conforming to `Decodable`.
    /// - Throws: A `NetworkError` if the request fails due to a bad URL, network issue, or decoding error.
    /// - Returns: A decoded object of the specified type.
    public func call<T: Decodable>(
        baseURL: String,
        method: DCNetworkMethod = .get,
        params: DCRequestParams? = nil,
        of type: T.Type
    ) async throws -> T where T: Decodable {
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.addQueryParams(params)
        
        guard let url = urlComponents?.url else {
            throw DCNetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.addRequestParams(params)
        
        do {
            let (data, response) = try await urlSession.getDataFrom(request, type: T.self)
            
            guard let response = response as? HTTPURLResponse else {
                throw DCNetworkError.badResponse
            }
            
            Log.thisRequest(response, data: data, request: request)
            
            switch response.statusCode {
            case 200..<300:
                return try JSONDecoder().decode(T.self, from: data)
            case 400..<499:
                throw DCNetworkError.badRequest
            case 500..<504:
                throw DCNetworkError.serverError
            default:
                throw DCNetworkError.badResponse
            }
        } catch {
            throw DCNetworkError.badRequest
        }
    }
}
