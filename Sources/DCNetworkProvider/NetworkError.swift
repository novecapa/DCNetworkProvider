//
//  NetworkError.swift
//  NetworkCom
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

public enum NetworkError: Error, Hashable {
    case badURL
    case badRequest
    case serverError
    case badResponse
}
