//
//  ApiError.swift
//  MarvelMVVM
//
//  Created by Daniel Rocha on 26/02/20.
//  Copyright © 2020 Daniel Rocha. All rights reserved.
//

import Foundation

public enum ApiError: Error {
    case notFound
    case unauthorized
    case badRequest
    case connectionFailure
    case requestError(Error)
    case malformedRequest
    case serverError
    case timeout
    case unknown
    case unitTest
}
