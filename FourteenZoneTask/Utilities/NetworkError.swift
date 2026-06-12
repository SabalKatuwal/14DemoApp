//
//  NetworkError.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
    case noCachedData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an unexpected response."
        case .httpError(let statusCode):
            return "Server error (HTTP \(statusCode)). Please try again."
        case .decodingFailed:
            return "Unable to read the data from the server."
        case .noCachedData:
            return "No cached data available."
        }
    }
}
