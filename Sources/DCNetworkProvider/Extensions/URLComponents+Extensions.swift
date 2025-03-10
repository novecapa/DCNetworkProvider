//
//  URLComponents+Extensions.swift
//  DCNetworkProvider
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

extension URLComponents {
    mutating func addQueryParams(_ queryParams: DCRequestParams?) {
        guard let query = queryParams else { return }
        switch query {
        case .query(let params):
            queryItems = params.compactMap { key, value in
                if let stringValue = value as? String, !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                if let stringValue = String(describing: value)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   !stringValue.isEmpty {
                    return URLQueryItem(name: key, value: stringValue)
                }
                return nil
            }
        default:
            break
        }
    }
}
