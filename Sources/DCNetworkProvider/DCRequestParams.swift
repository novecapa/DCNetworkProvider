//
//  DCRequestParams.swift
//  NetworkCom
//
//  Created by Josep Cerdá Penadés on 10/3/25.
//

import Foundation

public enum DCRequestParams: Sendable {
    case query([String: any Sendable])
    case bodyRaw(Data)
    case multipart([String: any Sendable])
    case urlEncoded([String: any Sendable])
    case headers([String: any Sendable])
}
