//
//  DCNetworkClientProtocol.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

public protocol DCNetworkClientProtocol {
    func call<T: Decodable>(baseURL: String,
                            method: DCNetworkMethod,
                            params: DCRequestParams?,
                            of type: T.Type) async throws -> T
}
