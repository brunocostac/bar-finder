//
//  BusinessInformationViewControllerTests.swift
//  bar-finderTests
//
//  Created by Bruno Costa on 03/04/23.
//

import XCTest
import CoreData
@testable import bar_finder

class BusinessInformationViewControllerTests: XCTestCase {
    
    var sut: BusinessInformationViewController!
    var favoriteManager: FavoriteManager!
    var coreDataStack: CoreDataTestStack!
    var delegateMock: BusinessInformationViewControllerDelegateMock!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        delegateMock = BusinessInformationViewControllerDelegateMock()
        favoriteManager = FavoriteManager(mainContext: coreDataStack.mainContext)
        sut = BusinessInformationViewController(for: nil, with: "test-id", near: "test-location")
        sut.delegate = delegateMock
        
        // Given
        let category = Category(title: "Coffee & Tea")
        let location = Location(address1: "456 Second St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates = Coordinates(latitude: 37.7773, longitude: -122.3932)

        let business = Business(id: "def456", alias: "blue-bottle-coffee-san-francisco", name: "Blue Bottle Coffee", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/blue-bottle-coffee-san-francisco", phone: "+14155551234", displayPhone: "(415) 555-1234", reviewCount: 500, categories: [category], rating: 4.8, location: location, coordinates: coordinates, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/9tjrJ0tHEvFt0UMZ8u_JVA/o.jpg"], price: "$", transactions: ["delivery", "pickup"], distance: 1.0)
        
        sut.business = business

    }
    
    override func tearDown() {
        sut = nil
        coreDataStack = nil
        delegateMock = nil
        favoriteManager = nil
        super.tearDown()
    }
    
    func test_toggleFavoriteIfFavoriteIsTrue() {
        // GIVEN
        
        sut.isFavorite = true
        
        // WHEN
        
        sut.toggleFavorite(business: sut.business)
        
        // THEN
        XCTAssertFalse(sut.isFavorite)
    }
    
    func test_toggleFavoriteIfFavoriteIsFalse() {
        
        // GIVEN
        sut.isFavorite = false
        
        // WHEN
        sut.toggleFavorite(business: sut.business)
        
        // THEN
        
        XCTAssertTrue(sut.isFavorite)
    }
    
    func test_checkFavoriteIsFalse() {
        
        // GIVEN
        
        let category = Category(title: "Italian")
        let location = Location(address1: "123 Main St", city: "San Francisco", zipCode: "94110", state: "CA")
        let coordinates = Coordinates(latitude: 37.7749, longitude: -122.4194)

        let business = Business(id: "2", alias: "tonys-pizza-san-francisco", name: "Tony's Pizza", imageURL: "https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg", isClaimed: true, isClosed: false, yelpUrl: "https://www.yelp.com/biz/tonys-pizza-san-francisco", phone: "+14155555555", displayPhone: "(415) 555-5555", reviewCount: 100, categories: [category], rating: 4.5, location: location, coordinates: coordinates, photos: ["https://s3-media3.fl.yelpcdn.com/bphoto/mM8yvcxgKkpxtZs0ft1sMQ/o.jpg"], price: "$$", transactions: ["delivery", "pickup"], distance: 2.5)
        
        // WHEN
        
        sut.checkIsFavorite(business: business)
        
        // THEN
        
        XCTAssertFalse(sut.isFavorite)
    }
    
    func test_checkFavoriteIsTrue() {
        
        // WHEN
        sut.checkIsFavorite(business: sut.business)
        
        // THEN
        
        XCTAssertTrue(sut.isFavorite)
    }
    
    
    func test_viewControllerDidDismiss_delegateMethodGetsCalled() {
        // Given
        XCTAssertNotNil(sut.delegate)
        
        // When
        sut.dismissVC()
        
        // Then
        XCTAssertTrue(delegateMock.businessInformationViewControllerDidDismissGotCalled)
    }
    
}

class BusinessInformationViewControllerDelegateMock: BusinessInformationViewControllerDelegate {
    var businessInformationViewControllerDidDismissGotCalled = false
    
    func businessInformationViewControllerDidDismiss(_ viewController: BusinessInformationViewController) {
        businessInformationViewControllerDidDismissGotCalled = true
    }
}
