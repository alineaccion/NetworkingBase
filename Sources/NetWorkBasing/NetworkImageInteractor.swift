//
// NetworkImageInteractor.swift
//
//
//  Created by Ali on 15/1/25.
//

import UIKit

public protocol NetworkImageInteractor: NetworkInteractor {}

public extension NetworkImageInteractor {
    func getImage(url: URL) async throws -> UIImage {
        try await get(request: URLRequest.get(url: url)) { data in
            guard let image = UIImage(data: data) else {
                throw NetworkError.dataNotValid
            }
            return image
        }
    }
}
