//
//  Movie+CoreDataProperties.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 25/08/23.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: String?
    @NSManaged public var isAddedToWatchlist: Bool

}

//extension Movie : Identifiable {
//
//}
