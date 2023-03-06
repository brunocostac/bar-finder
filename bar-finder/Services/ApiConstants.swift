//
//  ApiConstants.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation

enum ApiConstants {
    
    static private let clientId = ""
    static private let authPrefix = "Bearer"
    static private let apiKey = ""
    static let authString = Self.authPrefix + " " + Self.apiKey
    
    internal enum Endpoint {
        static let baseSearch = "https://api.yelp.com/v3/businesses/search"
        static let baseGetById = "https://api.yelp.com/v3/businesses/"
        
        static func addAddress(_ address: String) -> String { "location=\(address)" }
        static func addBusinessType(_ businessType: String) -> String { "term=\(businessType)" }
        
        static let defaultRadiusAndBatchLimit = "radius=2000&sort_by=distance&limit=\(BusinessDataService.shared.batchSize)"
    }
}
