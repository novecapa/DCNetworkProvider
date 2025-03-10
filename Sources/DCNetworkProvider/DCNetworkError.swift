//
//  DCNetworkError.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

public enum DCNetworkError: Error, Hashable {
    case badURL
    case badRequest
    case serverError
    case badResponse
}
