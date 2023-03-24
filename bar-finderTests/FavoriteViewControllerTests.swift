//
//  FavoriteViewControllerTests.swift
//  bar-finderTests
//
//  Created by Bruno Costa on 23/03/23.
//

import XCTest
import CoreData
@testable import bar_finder

class FavoriteListViewControllerTests: XCTestCase {
    
    var sut: FavoriteListViewController!
    var mockFavoriteManager: MockFavoriteManager!
    var coreDataStack: CoreDataTestStack!
    var sampleFavorites: [Favorite] = []
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        mockFavoriteManager = MockFavoriteManager(persistentContainer: coreDataStack.persistentContainer)
        sut = FavoriteListViewController()
        sut.tableView.register(FavoriteListCell.self, forCellReuseIdentifier: "FavoriteListCell")
        sut.favoriteManager = mockFavoriteManager
        
        // Create some sample Favorite objects for testing
        let favorite1 = Favorite(context: coreDataStack.mainContext)
        favorite1.id = "1"
        favorite1.name = "Restaurant A"
        favorite1.imageURL = "https://example.com/image1.jpg"
        favorite1.rating = 4.5
        favorite1.category = "Italian"
        
        let favorite2 = Favorite(context: coreDataStack.mainContext)
        favorite2.id = "2"
        favorite2.name = "Restaurant B"
        favorite2.imageURL = "https://example.com/image2.jpg"
        favorite2.rating = 3.8
        favorite2.category = "Mexican"
        
        sut.allFavorites =  [favorite1, favorite2]
    }
    
    override func tearDown() {
        sut = nil
        mockFavoriteManager = nil
        coreDataStack = nil
        super.tearDown()
    }
    
    func testNumberOfRowsInSection() {
    
        // When
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, sut.allFavorites.count)
    }
    
    // Test that the table view cell is configured correctly
    func testCellForRowAtIndexPath() {
        // Given
        let favorite1 = Favorite(context: coreDataStack.mainContext)
        favorite1.id = "1"
        favorite1.name = "Restaurant A"
        favorite1.imageURL = "https://example.com/image1.jpg"
        favorite1.rating = 4.5
        favorite1.category = "Italian"
        
        let indexPath = IndexPath(row: 0, section: 0)
        sut.allFavorites = [favorite1]
        
        // When
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! FavoriteListCell
        
        // Then
        XCTAssertEqual(cell.nameLabel.text, favorite1.name)
        XCTAssertEqual(cell.ratingLabel.text, "\(favorite1.rating)")
    }
}
