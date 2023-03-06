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
        let category = Category(title: "Bar")
        let bar = Business(id: "2", name: "Bar da Maria", imageURL: "dhasudhashda", isClosed: false, yelpUrl: "adhsuahsduashusad", categories: [category], rating: 4.0, coordinates: Coordinates(latitude: 20.33, longitude: 32.00), distance: 2.0)
        favoriteManager.save(business: bar)
        
        let favorite = favoriteManager.fetch(withId: bar.id)
        
        XCTAssertEqual("2", favorite?.id)
    }
    
    func test_remove_favorite() {
        let category = Category(title: "Bar")
        let bar =  Business(id: "4", name: "Bar do Zeca", imageURL: "dhasudhashda", isClosed: false, yelpUrl: "adhsuahsduashusad", categories: [category], rating: 4.0, coordinates: Coordinates(latitude: 20.33, longitude: 32.00), distance: 2.0)
        
        favoriteManager.save(business: bar)
        
        favoriteManager.remove(withId: bar.id)
        
        let favorite = favoriteManager.fetch(withId: bar.id)
        
        XCTAssertNil(favorite)
    }
    
    func test_fetch_all_favorites() {
        let category = Category(title: "Bar")
        let bar1 = Business(id: "5", name: "Bar do Jose", imageURL: "dhasudhashda", isClosed: false, yelpUrl: "adhsuahsduashusad", categories: [category], rating: 4.0, coordinates: Coordinates(latitude: 20.33, longitude: 32.00), distance: 2.0)
        
        let bar2 = Business(id: "4", name: "Bar da Maria", imageURL: "dhasudhashda", isClosed: false, yelpUrl: "adhsuahsduashusad", categories: [category], rating: 4.0, coordinates: Coordinates(latitude: 20.33, longitude: 32.00), distance: 2.0)
        
        favoriteManager.save(business: bar1)
        favoriteManager.save(business: bar2)
        
        let favorites = favoriteManager.fetchAll()
        
        XCTAssertEqual(favorites?.count, 2)
    }
}
