//
//  CoreDataManager.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 25/08/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
//    func toggleMovieInWatchlist(item: Movie) {
//        item.isInWatchlist.toggle()
//
//        do {
//            try context.save() // Save the context to persist the changes
//        } catch {
//            print("Error saving context: \(error)")
//
//        }
//    }
}

extension CoreDataManager {
    func fetchMovieWithID(_ id: Int) -> Movie? {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let movies = try context.fetch(fetchRequest)
            return movies.first
        } catch {
            print("Error fetching movie: \(error)")
            return nil
        }
    }
}
