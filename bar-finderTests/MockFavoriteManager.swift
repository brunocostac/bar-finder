//
//  MockFavoriteManager.swift
//  bar-finderTests
//
//  Created by Bruno Costa on 23/03/23.
//

import Foundation

@testable import bar_finder
import CoreData


class MockFavoriteManager: FavoriteManagerProtocol {
  
    let persistentContainer: NSPersistentContainer
    var mockFavorites: [Favorite] = []

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func fetchAll() -> [Favorite]? {
        return mockFavorites
    }
    
    func save(business: Business) {
        
    }
    
    func fetch(withId id: String) -> Favorite? {
        return mockFavorites.first
    }
    
    func remove(withId id: String) {
        
    }
}
