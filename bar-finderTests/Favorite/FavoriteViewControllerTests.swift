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
        _ = sut.view
        sut.tableView.register(FavoriteListCell.self, forCellReuseIdentifier: "FavoriteListCell")
    }
    
    override func tearDown() {
        sut = nil
        coreDataStack = nil
        super.tearDown()
    }
    
    func test_viewDidLoad() {
        let viewController = FavoriteListViewController()
        viewController.viewDidLoad()
        
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        XCTAssertEqual(viewController.title, NSLocalizedString("Favoritos", comment: ""))
        XCTAssertNotNil(viewController.tableView.delegate)
        XCTAssertNotNil(viewController.tableView.dataSource)
        XCTAssertEqual(viewController.tableView.rowHeight, 72)
    }
  
    func testNumberOfRowsInSection() {
        // When
        let numberOfRows = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, sut.allFavorites.count)
    }
    
    func test_fetchFavorites() {
        let viewController = FavoriteListViewController()
        viewController.favoriteManager = mockFavoriteManager
        viewController.viewDidLoad()
        
        
        let favorite1 = Favorite(context: coreDataStack.mainContext)
        favorite1.id = "1"
        favorite1.name = "Restaurant A"
        favorite1.imageURL = "https://example.com/image1.jpg"
        favorite1.rating = 4.5
        favorite1.category = "Italian"
        
        mockFavoriteManager.mockFavorites.append(favorite1)
        
        viewController.fetchFavorites()
       
        XCTAssertTrue(viewController.tableView.numberOfRows(inSection: 0) == mockFavoriteManager.mockFavorites.count)
    }

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
    
    func test_setupEmptyStateView_whenFavoritesIsEmpty() {
        let viewController = FavoriteListViewController()
        viewController.viewDidLoad()
        
        viewController.allFavorites = []
        viewController.tableView.reloadData()
        viewController.setupEmptyStateView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(viewController.view.subviews.contains { $0 is BFEmptyStateView })
        }
    }

    func test_setupEmptyStateView_whenFavoritesIsNotEmpty() {
        let viewController = FavoriteListViewController()
        viewController.viewDidLoad()
        let favorite1 = Favorite(context: coreDataStack.mainContext)
        favorite1.id = "1"
        favorite1.name = "Restaurant A"
        favorite1.imageURL = "https://example.com/image1.jpg"
        favorite1.rating = 4.5
        favorite1.category = "Italian"
        
        viewController.allFavorites = [favorite1]
        viewController.tableView.reloadData()
        viewController.setupEmptyStateView()
        
        XCTAssertFalse(viewController.view.subviews.contains { $0 is BFEmptyStateView })
    }
}
