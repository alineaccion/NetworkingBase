//
// NetworkInteractor.swift
//
//
//  Created by Ali on 15/1/25.
//

import UIKit

public protocol NetworkInteractor: Sendable {
    var session: URLSession { get }
}

public extension NetworkInteractor {
    var session: URLSession { .shared }
    
    func post(request: URLRequest, status: Int = 200) async throws {
        let (_, response) = try await session.getData(for: request)
        if response.statusCode != status {
            throw NetworkError.status(response.statusCode)
        }
    }
}

extension NetworkInteractor {
    func get<T>(request: URLRequest, builder: (Data) throws -> T) async throws -> T {
        let (data, response) = try await session.getData(for: request)
        if response.statusCode == 200 {
            return try builder(data)
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
}
