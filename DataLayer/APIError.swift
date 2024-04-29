//
//  APIError.swift
//  VeterinaryApp
//
//  Created by Tanmay on 12/04/23.
//

import Foundation

enum APIError: Error, LocalizedError {
    case noInternet
    case invalidURL
    case unknownStatusCode(error: String? = nil)
    case unknown
    case apiError(reason: String)
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "Please check your internet connection"
        case .invalidURL:
            return "Invalid URL"
        case .unknownStatusCode(let error):
            return "Invalid Status Code" + (error ?? "")
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        }
    }
}
