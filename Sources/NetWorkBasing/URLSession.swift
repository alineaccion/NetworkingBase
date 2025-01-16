//
// URLSession.swift
//
//
//  Created by Ali on 15/1/25.
//

import Foundation

public extension URLSession {
    func getData(from url: URL) async throws -> (data: Data, response: HTTPURLResponse) {
        try await getData(for: URLRequest(url: url))
    }
    
    func getData(for request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        do {
            let (data, response) = try await data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.nonHTTP
            }
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
}
