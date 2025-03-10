//
//  NetworkClient.swift
//  NetworkCom
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

/// A network client responsible for making HTTP requests and decoding responses.
///
/// This class conforms to `NetworkClientProtocol` and provides an asynchronous method
/// to perform network calls using `URLSession`.
public final class NetworkClient: NetworkClientProtocol {
    
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
        method: NetworkMethod = .get,
        params: RequestParams? = nil,
        of type: T.Type
    ) async throws -> T where T: Decodable {
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.addQueryParams(params)
        
        guard let url = urlComponents?.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.addRequestParams(params)
        
        do {
            let (data, response) = try await urlSession.getDataFrom(request, type: T.self)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.badResponse
            }
            
            Log.thisRequest(response, data: data, request: request)
            
            switch response.statusCode {
            case 200..<300:
                return try JSONDecoder().decode(T.self, from: data)
            case 400..<499:
                throw NetworkError.badRequest
            case 500..<504:
                throw NetworkError.serverError
            default:
                throw NetworkError.badResponse
            }
        } catch {
            throw NetworkError.badRequest
        }
    }
}
