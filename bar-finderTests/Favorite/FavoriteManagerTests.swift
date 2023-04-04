//
//  bar_finderTests.swift
//  bar-finderTests
//
//  Created by Bruno Costa on 09/02/23.
//

import XCTest
import CoreData
@testable import bar_finder

final class FavoriteManagerTests: XCTestCase {
    var favoriteManager: FavoriteManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        favoriteManager = FavoriteManager(mainContext: coreDataStack.mainContext)
    }
    
    func test_create_favorite_if_not_exists_with_id() {
        XCTAssertNil(favoriteManager.fetch(withId: "2"))
        
        let category = Category(title: "Italian")
        let location = Location(address1: "123 Main St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)

        let business = Business(id: "2", alias: "tonys-pizza-san-francisco", name: "Tony's Pizza", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/tonys-pizza-san-francisco", phone: "+14155555555", displayPhone: "(415) 555-5555", reviewCount: 100, categories: [category], rating: 4.5, location: location, coordinates: coordinates, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg"], price: "$$", transactions: ["delivery", "pickup"], distance: 2.5)
        
        favoriteManager.save(business: business)
        
        let favorite = favoriteManager.fetch(withId: business.id)
        
        XCTAssertEqual("2", favorite?.id)
    }
    
    func test_remove_favorite() {
        let category = Category(title: "Coffee & Tea")
        let location = Location(address1: "456 Second St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates = Coordinates(latitude: 37.7773, longitude: -122.3932)

        let business = Business(id: "def456", alias: "blue-bottle-coffee-san-francisco", name: "Blue Bottle Coffee", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/blue-bottle-coffee-san-francisco", phone: "+14155551234", displayPhone: "(415) 555-1234", reviewCount: 500, categories: [category], rating: 4.8, location: location, coordinates: coordinates, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg"], price: "$", transactions: ["delivery", "pickup"], distance: 1.0)

        
        favoriteManager.save(business: business)
        
        favoriteManager.remove(withId: business.id)
        
        let favorite = favoriteManager.fetch(withId: business.id)
        
        XCTAssertNil(favorite)
    }
    
    func test_fetch_all_favorites() {
        // Business 1
        let category1 = Category(title: "Italian")
        let location1 = Location(address1: "123 Main St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates1 = Coordinates(latitude: 37.7749, longitude: -122.4194)

        let business1 = Business(id: "abc123", alias: "tonys-pizza-san-francisco", name: "Tony's Pizza", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/tonys-pizza-san-francisco", phone: "+14155555555", displayPhone: "(415) 555-5555", reviewCount: 100, categories: [category1], rating: 4.5, location: location1, coordinates: coordinates1, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg"], price: "$$", transactions: ["delivery", "pickup"], distance: 2.5)

        // Business 2
        let category2 = Category(title: "Coffee & Tea")
        let location2 = Location(address1: "456 Second St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates2 = Coordinates(latitude: 37.7773, longitude: -122.3932)

        let business2 = Business(id: "def456", alias: "blue-bottle-coffee-san-francisco", name: "Blue Bottle Coffee", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/blue-bottle-coffee-san-francisco", phone: "+14155551234", displayPhone: "(415) 555-1234", reviewCount: 500, categories: [category2], rating: 4.8, location: location2, coordinates: coordinates2, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg"], price: "$", transactions: ["delivery", "pickup"], distance: 1.0)

        // Business 3
        let category3 = Category(title: "Sushi Bars")
        let location3 = Location(address1: "789 Third St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates3 = Coordinates(latitude: 37.7844, longitude: -122.4064)

        let business3 = Business(id: "789xyz", alias: "coffee-shop-san-francisco", name: "Joe's Coffee Shop", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/bcTEmjsJGOzR-YlXRC1uVg/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/coffee-shop-san-francisco", phone: "+14155555557", displayPhone: "(415) 555-5557", reviewCount: 50, categories: [category3], rating: 4.0, location: location3, coordinates: coordinates3, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/bcTEmjsJGOzR-YlXRC1uVg/o.jpg"], price: "$", transactions: ["delivery", "pickup"], distance: 1.2)
        
        favoriteManager.save(business: business1)
        favoriteManager.save(business: business2)
        favoriteManager.save(business: business3)
        
        let favorites = favoriteManager.fetchAll()
        
        XCTAssertEqual(favorites?.count, 3)
    }
}
