//
//  ApiConstants.swift
//  bar-finder
//
//  Created by Bruno Costa on 14/02/23.
//

import Foundation

enum YelpAPIConstants {
    
    static private let yelpAPIClientID = ""
    static private let authPrefix = "Bearer"
    static private let yelpAPIKey = ""
    static let yelpAPIAuthorizationString = Self.authPrefix + " " + Self.yelpAPIKey
    
    internal enum YelpAPIEndpoint {
        static let searchEndpointBaseURL = "https://api.yelp.com/v3/businesses/search"
        static let getBusinessByIDEndpointBaseURL = "https://api.yelp.com/v3/businesses/"
        
        static func locationSearchQueryParameter(_ address: String) -> String { "location=\(address)" }
        static func businessTypeSearchQueryParameter(_ businessType: String) -> String { "term=\(businessType)" }
        
        static let defaultSearchRadiusAndBatchLimitQueryParameter = "radius=2000&sort_by=distance&limit=\(BusinessDataService.shared.batchSize)"
    }
}
