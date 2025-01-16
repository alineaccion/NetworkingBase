//
// CGSize.swift
//
//
//  Created by Ali on 15/1/25.
//

import Foundation

public extension CGSize {
    func thumbnailCGSize(width: CGFloat? = nil, height: CGFloat? = nil) -> CGSize {
        switch (width, height) {
            case (nil, nil):
                return CGSize.zero
            case (let width?, nil):
                let scale = width / width
                return CGSize(width: width, height: self.height * scale)
            case (nil, let height?):
                let scale = height / height
                return CGSize(width: self.width * scale, height: height)
            case let (width?, height?):
                return CGSize(width: width, height: height)
        }
    }
}
