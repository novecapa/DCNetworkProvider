//
//  NetworkClientProtocol.swift
//  NetworkCom
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

public protocol NetworkClientProtocol {
    func call<T: Decodable>(baseURL: String,
                            method: NetworkMethod,
                            params: RequestParams?,
                            of type: T.Type) async throws -> T
}
