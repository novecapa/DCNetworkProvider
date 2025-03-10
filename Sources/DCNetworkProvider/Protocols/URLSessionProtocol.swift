//
//  URLSessionProtocol.swift
//  NetworkCom
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

public protocol URLSessionProtocol {
    func getDataFrom<T: Decodable>(_ request: URLRequest,
                                   type: T.Type) async throws -> (Data, URLResponse)
}
