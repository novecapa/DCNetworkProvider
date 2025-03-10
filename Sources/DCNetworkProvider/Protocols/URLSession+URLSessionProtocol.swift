//
//  URLSession+URLSessionProtocol.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func getDataFrom<T: Decodable>(_ request: URLRequest,
                                          type: T.Type) async throws -> (Data, URLResponse) {
        try await data(for: request)
    }
}
