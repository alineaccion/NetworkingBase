//
// JSONEncoderDecoder.swift
//
//
//  Created by Ali on 15/1/25.
//

import Foundation

public extension JSONDecoder {
    static let isoDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

public extension JSONEncoder {
    static let isoEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}
