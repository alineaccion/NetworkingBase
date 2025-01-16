//
// NetworkJSONInteractor.swift
//
//
//  Created by Ali on 15/1/25.
//

import Foundation

public protocol NetworkJSONInteractor: NetworkInteractor {}

public extension NetworkJSONInteractor {
    var session: URLSession { .shared }
    
    func getJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        try await get(request: request) { data in
            do {
                return try JSONDecoder.isoDecoder.decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        }
    }
}
  
