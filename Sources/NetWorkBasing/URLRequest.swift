//
// URLRequest.swift
//
//
//  Created by Ali on 15/1/25.
//

import Foundation

public enum AuthType {
    case basic
    case token
}

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public extension URLRequest {
    static func get(url: URL, 
                    token: String? = nil,
                    authType: AuthType = .token) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        switch authType {
            case .basic:
                if let token {
                    request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
                }
            case .token:
                if let token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
        }
        return request
    }
    
    static func post<JSON>(url: URL, 
                           post: JSON,
                           method: HTTPMethod = .post,
                           token: String? = nil,
                           authType: AuthType = .token) -> URLRequest where JSON: Codable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder.isoEncoder.encode(post)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        switch authType {
            case .basic:
                if let token {
                    request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
                }
            case .token:
                if let token {
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
        }
        return request
    }
}
