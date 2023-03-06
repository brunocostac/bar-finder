//
//  Bar.swift
//  bar-finder
//
//  Created by Bruno Costa on 09/02/23.
//

import Foundation

struct Business: Codable {
    let id: String
    let alias: String?
    let name: String
    let imageURL: String
    let isClaimed: Bool?
    let isClosed: Bool
    let yelpUrl: String
    let phone: String?
    let displayPhone: String?
    let reviewCount: Int?
    let categories: [Category]
    let rating: Double
    let location: Location?
    let coordinates: Coordinates
    let photos: [String]?
    let price: String?
    let transactions: [String]?
    let distance: Double?
   
    enum CodingKeys: String, CodingKey {
        case id, alias, name, imageURL = "image_url", isClaimed = "is_claimed",
             isClosed = "is_closed", yelpUrl = "url", phone, displayPhone = "display_phone",
             reviewCount = "review_count", categories, rating, location, coordinates,
             photos, price, transactions, distance
    }
    
    var readableCategories: String {
        var tags: [String] = []
        for eachCategory in categories {
            if let tag = eachCategory.title { tags.append(tag) }
        }
        return tags.joined(separator: ", ")
    }
}

extension Business: Hashable {
    static func == (lhs: Business, rhs: Business) -> Bool { lhs.id == rhs.id }
}

// MARK: - Category
struct Category: Codable, Hashable {
    var title: String?
}

struct Coordinates: Codable, Hashable {
    var latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable, Hashable {
    var address1, address2: String?
    var city, zipCode, state: String?
    var displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case address1, address2
        case city = "city"
        case zipCode = "zip_code"
        case state = "state"
        case displayAddress = "display_address"
    }
}

