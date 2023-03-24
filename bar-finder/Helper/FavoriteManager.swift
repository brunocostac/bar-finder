//
//  FavoriteManager.swift
//  bar-finder
//
//  Created by Bruno Costa on 09/02/23.
//

import Foundation
import CoreData

protocol FavoriteManagerProtocol {
    func save(business: Business)
    func fetch(withId id: String) -> Favorite?
    func fetchAll() -> [Favorite]?
    func remove(withId id: String)
}

struct FavoriteManager: FavoriteManagerProtocol {
    let mainContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    @discardableResult
    func save(business: Business) {
        let favorite = Favorite(context: mainContext)
        favorite.setValue(business.id, forKey: "id")
        favorite.setValue(business.name, forKey: "name")
        favorite.setValue(business.rating, forKey: "rating")
        favorite.setValue(business.imageURL, forKey: "imageURL")
        favorite.setValue(business.categories.first?.title, forKey: "category")

        do {
            try mainContext.save()
        } catch {
            print("Failed to create: \(error)")
        }
    }
    
    func fetch(withId id: String) -> Favorite? {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let predicate = NSPredicate(format: "(id MATCHES %@)", id)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let favorites = try mainContext.fetch(request)
            return favorites.first
        } catch let error {
          print("Error fetching data from context \(error)")
        }
        return nil
    }
    
    func fetchAll() -> [Favorite]? {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            let favorites = try mainContext.fetch(request)
            return favorites
        } catch {
            return nil
        }
    }
    
    func remove(withId id: String) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "(id MATCHES %@)", id)
        
        do {
            let fetchedResults = try mainContext.fetch(request)
            if let result = fetchedResults.first {
                mainContext.delete(result)
                try mainContext.save()
            }
        } catch let error {
            print("Failed to delete: \(error)")
        }
    }
}
